    
    var rc;
    
    $(document).ready(function(){

        $('a, button').on('click',function(){
            var that = this;
            setTimeout( function(){
                that.blur();
            },10);
        });
        
        rc = $('#rc').rc();
        
        
    });