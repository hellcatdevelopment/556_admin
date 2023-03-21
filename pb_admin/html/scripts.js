$(document).ready(function(){
  // Partial Functions
  function openmap1() {
    $(".open-picturetohtml").css("display", "block");
    $(".close").css("display", "block");
    $(".god").css("display", "block");
    $(".noclip").css("display", "block");
    $(".pnames").css("display", "block");
    $(".invisible").css("display", "block");
    $(".heal").css("display", "block");
    $(".id").css("display", "block");
  }
  function closemap1() {
    $(".open-picturetohtml").css("display", "none");
    $(".close").css("display", "none");
    $(".god").css("display", "none");
    $(".noclip").css("display", "none");
    $(".pnames").css("display", "none");
    $(".invisible").css("display", "none");
    $(".heal").css("display", "none");
    $(".id").css("display", "none");
  }
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Open & Close main bank window
    if(item.openPicture == true) {
      openmap1();
    }
    if(item.openPicture2 == true) {
      openmap2();
    }
    if(item.closePicture == false) {
      closemap1();
    }
    if(item.closePicture2 == false) {
      closemap2();
    }
  });
  $(".close").click(function() {
      $.post("http://556_admin/exit", JSON.stringify({}));
  })
  $(".god").click(function() {
    $.post("http://556_admin/god", JSON.stringify({}));
})
$(".noclip").click(function() {
  $.post("http://556_admin/noclip", JSON.stringify({}));
})
$(".pnames").click(function() {
  $.post("http://556_admin/pnames", JSON.stringify({}));
})
$(".invisible").click(function() {
  $.post("http://556_admin/invisible", JSON.stringify({}));
})
$(".heal").click(function() {
  $.post("http://556_admin/heal", JSON.stringify({}));
})
$(".id").click(function() {
  $.post("http://556_admin/id", JSON.stringify({}));
})
});