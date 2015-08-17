SlideBehaviors['video'] = {

  /**
   * Public Methods
   */

  initialize: function(slide) {
    this.bg_video = slide.$element.find('video#js-background-video').get(0);
    this.fg_video = slide.$element.find('video#js-foreground-video').get(0);
  },

  play: function() {
    if (this.bg_video) {
      this.bg_video.play();
    }
    if (this.fg_video) {
      this.fg_video.play();
    }
  },

  stop: function() {
    if (this.bg_video) {
      this.bg_video.pause();
      this.bg_video.currentTime = 0;
    }
    if (this.fg_video) {
      this.fg_video.pause();
      this.fg_video.currentTime = 0;
    }
  },

  /**
   * Private
   */
  bg_video: null,
  fg_video: null
};