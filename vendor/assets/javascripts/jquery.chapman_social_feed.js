/***********************************************************************
* CONSTRUCTOR
*/

ChapmanSocialFeed = function(options) {
  if (!options) var options = {};

  this.$element                      = options.$element;
  this.url                           = options.url                           || 'https://social.chapman.edu';
  this.load_more_url                 = options.load_more_url                 || this.loadMoreUrl();
  this.post_width                    = options.post_width                    || (this.$element.hasClass("vertical") ? 332 : 355);
  this.gutter_width                  = options.gutter_width                  || 20;
  this.max_columns                   = options.max_columns                   || 4;
  this.realtime                      = options.realtime                      || false;
  this.realtime_server_url           = options.realtime_server_url           || 'https://social.chapman.edu:8000/faye';
  this.realtime_subscription_channel = options.realtime_subscription_channel || this.realtimeSubscriptionChannel();
  this.realtimePostReceive           = options.realtimePostReceive           || this.defaultRealtimePostReceive;
  this.realtimePostRemove            = options.realtimePostRemove            || this.defaultRealtimePostRemove;
  this.infinite_scroll               = options.infinite_scroll               || false;
  this.scroll_last_fired             = options.scroll_last_fired             || 0;

  this.load_more_params  = {
    page:   options.page  || 1,
    per:    options.per   || 30,
    before: this.currentTimeAsParam()
  };
  this.selectors = {
    posts:       '.post_tile',
    columns:     '.column',
    new_ribbons: '.new_ribbon'
  };
  this.state = {
    currently_loading: false
  };
  this.animation_queue = [];
  this.resize_timer    = null;
  this.keyword         = null;  // Will be set dynamically based on url.
};


/***********************************************************************
* INITIALIZERS
*/

ChapmanSocialFeed.prototype.initialize = function() {
  this.initializePosts();
  this.initializeRealtime();
  this.keyword = this.extractKeywordFromUrl();
  $(window).on('resize', this.onResize.bind(this));
  $(window).on('scroll', this.onWindowScroll.bind(this));
  this.$element.trigger('csf:initialized');

  // These log calls (and a couple other belows) can be uncommented to help
  // with troubleshooting.
  //console.log('ChapmanSocialFeed keyword set to:', this.keyword);
  //console.log('ChapmanSocialFeed subscribed to realtime channel:', this.realtime_subscription_channel, 'on', this.realtime_server_url)
};

ChapmanSocialFeed.prototype.initializePosts = function() {
  if (this.$element.children().length == 0) { // No posts
    this.$element.html(this.createNewColumns());
    this.loadMore();
  } else { // Already have 1st page
    this.layoutPostsInColumns({animate: true});
    this.load_more_params.page += 1;
  }
};

ChapmanSocialFeed.prototype.initializeRealtime = function() {
  if (!this.realtime) return;
  this.$element.trigger('csf:realtime_connecting')
  var realtime = new Faye.Client(this.realtime_server_url);
  var self = this;
  realtime.on('transport:up', function() { self.$element.trigger('csf:realtime_connected') });
  realtime.subscribe(self.realtime_subscription_channel, self.__realtimePostReceive.bind(self));
  realtime.subscribe('/social/remove', self.__realtimePostRemove.bind(self));
};

ChapmanSocialFeed.prototype.extractKeywordFromUrl = function() {
  // Source: https://stackoverflow.com/a/901144/6763239
  var self = this;
  var url = self.url;
  var name = 'keyword';

  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
      results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, " "));
};


/***********************************************************************
 * LAYOUT
 */

ChapmanSocialFeed.prototype.layoutPostsInColumns = function(options) {
  var use_animation   = (options && options.animate);
  var $posts          = (options && options.$posts) ? options.$posts : this.$element.find(this.selectors.posts);
  var scroll_position = $(window).scrollTop();
  this.sortPosts($posts);
  if (use_animation) {
    $posts.css('opacity', 0);
    this.addToAnimationQueue($posts);
  }
  this.$element.html(this.createNewColumns());
  this.appendPosts($posts);
  if (use_animation) {
    this.animatePosts();
  }
  $(window).scrollTop(scroll_position);
};

ChapmanSocialFeed.prototype.createNewColumns = function() {
  var column_divs = '';
  for (var i = 0; i < this.detectNumberOfColumns(); ++i) {
    column_divs += '<div class="column" id="social-feed-column-'+i+'"/>';
  }
  return $(column_divs);
};

ChapmanSocialFeed.prototype.detectNumberOfColumns = function() {
  var calculated =  Math.floor(this.$element.width() /  this.post_width);
  if      (calculated < 1)                 return 1;
  else if (calculated <= this.max_columns) return calculated;
  else                                     return this.max_columns;
};

ChapmanSocialFeed.prototype.sortPosts = function($posts) {
  $posts.sort(function(a, b) {
    return new Date($(b).data('timestamp')) - new Date($(a).data('timestamp'));
  });
};

ChapmanSocialFeed.prototype.appendPosts = function($posts) {
  var $columns = this.$element.find(this.selectors.columns);
  var self = this;
  $posts.each(function() {
    self.appendPostToShortestColumn($(this), $columns);
  });
};

ChapmanSocialFeed.prototype.appendPostToShortestColumn = function($post, $columns) {
  var column_heights = $.map($columns, function(col) { return $(col).height(); });
  var min_index = column_heights.indexOf(Math.min.apply(Math, column_heights));
  $columns.eq(min_index).append($post);
  this.attachPostListeners($post);
  this.$element.trigger('csf:post_appended', [$post]);
};

ChapmanSocialFeed.prototype.prependPosts = function ($posts) {
  var self = this
  $posts.each(function() { self.prependPost($(this)); });
  this.layoutPostsInColumns();
  this.animatePosts({reverse: true});
};

ChapmanSocialFeed.prototype.prependPost = function($post) {
  $post.prepend('<span class="new_ribbon">NEW</span>');
  var $dup = $("#"+$post[0].id);
  if ($dup.length > 0) {
    $dup.html($post.html());
  } else {
    $post.css('opacity', 0);
    this.addToAnimationQueue($post);
    this.$element.prepend($post);
  }
  this.$element.trigger('csf:post_prepended', [$post]);
};

ChapmanSocialFeed.prototype.attachPostListeners = function($posts) {
  $posts.each(function(){
    $(this).find('time').timeago();
    if ($(this).hasClass('post_photo')) {
      $(this).find('.view_message').on('mouseenter', function(e){
        $(this).siblings('.message').stop().slideDown(200);
      });
      $(this).find('.message').on('mouseleave', function(e){
        $(this).stop().slideUp(400);
      });
      $(this).on('mouseleave', function(e){
        $(this).children('.message').stop().slideUp(400);
      });
    }
    $(this).data('listeners_attached', true);
  });
};

ChapmanSocialFeed.prototype.addToAnimationQueue = function($posts) {
  var self = this;
  $posts.each(function(){
    self.animation_queue.push(this.id);
  });
};

ChapmanSocialFeed.prototype.animatePosts = function(options) {
  options = options || {};
  if (this.animation_queue.length === 0) {
    $(this.selectors.posts).css('opacity', 1);  // Just in case we missed some
    return;
  }
  var id = (options.reverse) ? this.animation_queue.pop() : this.animation_queue.shift();
  $('#' + id).css('opacity', 1);
  var self = this;
  setTimeout(function(){ self.animatePosts(options); }, 10);
};

ChapmanSocialFeed.prototype.removeNewRibbons = function() {
  $(this.selectors.new_ribbons).fadeOut(1000);
};


/************************************************************************************
 * LOAD MORE
 */

ChapmanSocialFeed.prototype.loadMore = function() {
  if (this.state.currently_loading) return 'Already Requested';
  this.state.currently_loading = true;
  this.$element.trigger('csf:load_more_started', [this.load_more_url, this.load_more_params]);
  var self = this;

  $.ajax({
    url: self.load_more_url,
    method: 'get',
    data: self.load_more_params,
    crossDomain: true,
    success: function(posts) {
      var $posts = $(posts);
      $posts.css('opacity', 0);
      self.addToAnimationQueue($posts);
      self.appendPosts($posts);
      self.animatePosts();
      self.load_more_params.page += 1;
      self.state.currently_loading = false;
      self.$element.trigger('csf:load_more_success', [$posts]);
    },
    error: function(e) {
      self.$element.trigger('csf:load_more_error', e);
    }
  });
};

ChapmanSocialFeed.prototype.currentTimeAsParam = function() {
  var now = new Date();
  return [now.getFullYear(), now.getMonth()+1, now.getDate(), now.getHours().toString() + now.getMinutes().toString()].join("-")
}

ChapmanSocialFeed.prototype.loadMoreUrl = function() {
  var parser  = document.createElement('a');
  parser.href = this.url;
  parser.pathname += 'feed';
  return parser.href;
};

ChapmanSocialFeed.prototype.realtimeSubscriptionChannel =  function() {
  var parser  = document.createElement('a');
  parser.href = this.url;
  return '/social' + parser.pathname.replace(/\/$/, '');
};


/***********************************************************************
 * REALTIME
 */

ChapmanSocialFeed.prototype.__realtimePostReceive = function(post) {
  //console.log('ChapmanSocialFeed.__realtimePostReceive:', post);

  // If feed has a keyword, make sure post contains that keyword.
  // See Issue #196: https://github.com/chapmanu/signage/issues/196
  if ( this.keyword ) {
    // Checks for keyword in post (case-insensitive).
    var insensitivePost = post.toLowerCase();
    var insensitiveKeyword = this.keyword.toLowerCase();
    var includesKeyword = insensitivePost.indexOf(insensitiveKeyword) !== -1;

    if ( ! includesKeyword ) {
      //console.log('Realtime post not displayed. Does not contain keyword', this.keyword);
      return;
    }
  }

  this.realtimePostReceive(post);
  this.$element.trigger('csf:realtime_post_received', [post]);
};

ChapmanSocialFeed.prototype.__realtimePostRemove = function(id) {
  this.realtimePostRemove(id);
  this.$element.trigger('csf:realtime_post_removed', [id]);
};

ChapmanSocialFeed.prototype.defaultRealtimePostReceive = function(post) {
  var $post = $(post);
  var $dup = $('#'+$post[0].id);
  if ($dup.length === 0) this.prependPosts($post);
};

ChapmanSocialFeed.prototype.defaultRealtimePostRemove = function(id) {
  $('#'+id).remove();
};


/***********************************************************************************
 * LISTENERS
 */

ChapmanSocialFeed.prototype.onResize = function(e) {
  var self = this;
  clearTimeout(self.resize_timer);
  self.resize_timer = setTimeout(function() {
    self.layoutPostsInColumns();
  }, 100);
};

ChapmanSocialFeed.prototype.onWindowScroll = function() {
  if ($('.post_tile').length === 0) return;
  this.throttle();
};

ChapmanSocialFeed.prototype.nearBottomOfPage = function() {
  return $(window).scrollTop() + 1750 >= $(document).height();
};

ChapmanSocialFeed.prototype.throttle = function() {
  var time = new Date().getTime();
  if(this.nearBottomOfPage() && time - this.scroll_last_fired >= 500){
    this.loadMore();
    this.scroll_last_fired = time;
  }
};


/***********************************************************************************
 * JQUERY PLUGIN
 */

$.fn.chapmanSocialFeed = function(options) {
  this.csf = new ChapmanSocialFeed($.extend(options, {$element: this}));
  this.csf.initialize();
  this.appendPosts  = this.csf.appendPosts.bind(this.csf);
  this.prependPosts = this.csf.prependPosts.bind(this.csf);
  return this;
};
