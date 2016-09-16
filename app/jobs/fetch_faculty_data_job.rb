class FetchFacultyDataJob < ActiveJob::Base
  queue_as :default

  URL = 'https://www.chapman.edu/_App_Data/merged-faculty.xml'
  MAP = {
  # XML NODE NAMES                      DATABASE COLUMN NAMES
    'DatatelId'                      => 'datatel_id',
    'FacLastName'                    => 'last_name',
    'FacFirstName'                   => 'first_name',
    'FacFullName'                    => 'full_name',
    'ChapEmail'                      => 'email',
    'OfficePhone'                    => 'phone',
    'ThumbnailPhoto'                 => 'thumbnail',
    'OfficeBuilding'                 => 'building_name',
    'OfficeBuildingSecondary'        => 'building_name_2',
    'OfficeLocationDetails'          => 'office_name',
    'OfficeLocationDetailsSecondary' => 'office_name_2'
  }

  def perform
    # Currently Faculty records are not modified anywhere within the application beyond this sync job, which is why we're using `delete_all`
    Faculty.delete_all
    xml = RestClient.get(FetchFacultyDataJob::URL)
    doc = Nokogiri::XML(xml)
    doc.xpath('//FacultyMember').each do |node|
      save_faculty_member(node)
    end
  end

  private
    def save_faculty_member(node)
      datatel_id = node.at('DatatelId').content
      faculty    = Faculty.where(datatel_id: datatel_id).first_or_initialize
      assign_attributes(node, faculty)
      validate_thumbnail(faculty)
      faculty.save!
    end

    def assign_attributes(node, faculty)
      FetchFacultyDataJob::MAP.each do |xml_name, attribute|
        faculty[attribute] = node.at(xml_name).try(:content)
      end
    end

    def validate_thumbnail(faculty)
      if faculty.thumbnail.blank? || faculty.thumbnail == '/'
        faculty.thumbnail = nil
      else
        faculty.thumbnail = 'http://www.chapman.edu' + faculty.thumbnail
      end
    end
end
