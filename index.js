/* Sun May 04 2014 00:36:41 GMT+0800 (CST) */
(function() {
  var Panel;

  Panel = (function() {
    function Panel() {
      console.log("hello world");
    }

    Panel.prototype.something = function() {
      return "something";
    };

    return Panel;

  })();

  module.exports = Panel;

}).call(this);
