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

    def background_types
      @_background_types ||= ['none', 'image', 'video']
    end

    def foreground_types
      @_foreground_types ||= ['none', 'image', 'video']
    end

    def foreground_sizings
      @_foreground_sizings ||= [['Exact Size', 'auto'], ['Fill Screen', 'cover'], ['Fill Screen (do not crop)', 'contain']]
    end

    def admission_types
      @_admission_types ||= ['Free', 'Tickets Required', 'Free - Registration Required', 'Sold out', 'Cancelled']
    end

    def audience_types
      @_audience_types ||= ['Students', 'Club Members', 'Members', 'Faculty', 'Staff', 'Faculty and Staff', 'Chapman', 'Campus and Community', 'Orange Community', 'Public']
    end
  end
end
