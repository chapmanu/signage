module SlideFormOptions
  extend ActiveSupport::Concern

  class_methods do
    def templates
      @templates ||= Dir[Rails.root.join('app', 'views', 'slides', 'templates', '*.html.erb')].map {|f| f[/\/_(.*)\.html\.erb$/, 1]}
    end

    def themes
      @_themes ||= ['dark', 'light'] # It's always the darkest before light
    end

    def layouts
      @_layouts ||= ['left', 'right'] # We are in America peeps, left then right
    end

    def directory_feeds
      @_directory_feeds ||= ['Beckman Hall', 'Moulton Hall', 'Musco Center for the Arts']
    end

    def organizers
      @_organizers ||= ['CES', 'Dodge', 'Stuff', 'Yeah!'] # Read all the file names of the image files
    end

    def background_types
      @_background_types ||= ['none', 'image', 'video']
    end

    def foreground_types
      @_foreground_types ||= ['none', 'image', 'video']
    end

    def foreground_sizings
      @_foreground_sizings ||= ['exact size', 'fill screen', 'fill screen (do not crop)']
    end
  end
end