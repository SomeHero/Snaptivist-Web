FB.Dom.getViewportInfo: function() {
  // W3C compliant, or fallback to body
  var root = (document.documentElement && document.compatMode == 'CSS1Compat')
    ? document.documentElement
    : document.body;
  return {
    scrollTop  : root.scrollTop || document.body.scrollTop,
    scrollLeft : root.scrollLeft,
    width      : self.innerWidth  ? self.innerWidth  : root.clientWidth,
    height     : self.innerHeight ? self.innerHeight : root.clientHeight
  };
