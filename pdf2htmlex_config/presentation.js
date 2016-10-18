var current_slide_index = 1;
var slide_total = 1;

$(document).ready(function() {
  slide_for_index(current_slide_index).show();
  slide_total = $(".pf").length;
});

function move_slide(next){

  if(next > slide_total){
    next = 1;
  }

  if(next <= 0) {
    next = slide_total;
  }

  slide_for_index(current_slide_index).hide();
  slide_for_index(next).show();
  current_slide_index = next;
}

function slide_for_index(index) {
  hex = index.toString(16);
  return $('[data-page-no="'+hex+'"]');
}

function move_deck_forward() {
  move_slide(current_slide_index + 1);
}
function move_deck_backward() {
  move_slide(current_slide_index - 1);
}

$(document).keydown(function(e) {

  // left
  if (e.keyCode === 37) {
    move_deck_forward();
    return false;
  }

  //right
  if (e.keyCode === 39) {
    move_deck_backward();
    return false;
  }

  // enter
  // if (e.keyCode === 13) {
  // show_slide(current_slide_index - 1);
  // return false;
  // }

  // esc
  // if (e.keyCode === 27) {
  // show_slide(current_slide_index - 1);
  // return false;
  // }
});

