    (function($) {
        $('h3').hover(function() {
            
            $this = $(this),
            $oC = $this.find(".activeDiv"),
            $nC = $this.find(".hidden");
            
            $oC.stop(true, true).fadeOut('fast');
            
            $this.stop(true, true).animate({
                width: '+=300',
                height: '+=300',
                bottom: '+=300'
            }, function() {
                $nC.fadeIn('fast');
            });
        
        }, function() {
            
            $nC.stop(true, true).fadeOut('fast');
            
            $this.stop(true, true).animate({
                width: '-=300',
                height: '-=300',
                bottom: '-=300'
            }, function() {
                $oC.fadeIn('fast');
            });
       
        });
        
    })(jQuery);   