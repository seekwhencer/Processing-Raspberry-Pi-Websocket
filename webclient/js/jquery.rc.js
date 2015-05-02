/**
 *  Beatsocket Client Interface
 *  Matthias Kallenbach | Berlin
 *  seekwhencer.de
 * 
 *   
 *  
 */
(function($) {

    var _ns = 'rc';

    var defaults = {
        
        params          : false,
        data            : false,
        setup           : false,
        setup_source    : 'setup.json',
    };

    // build
    $.fn[_ns] = function(args) {

        var target      = this;
        var $target     = $(this);
        var options     = {};
        var connection  = { command:false };
        var params      = args;
        var active_actions = [];

        if ($.type(options) !== 'object') {
            var options = {};
        }

        $.extend(true, options, defaults, args);
         
        // get the app setup json
        $.ajax( { url: options.setup_source, 
            async       : false,
            dataType    : 'text',
            success     : function(data) {
                options.setup = $.parseJSON(data);
            }
        });
            
        
        // init
        function run(args) {
            
            var that = $(this);
            assumeSettings();
            
            $('#btnConnect').on('click',function(){
                connectToCommandServer();
            });
            
            $('#btnDisconnect').on('click',function(){
                closeCommandServer();
                $(target).css({opacity:0.5});
            });
            
            $('.page-panel a').on('click',function(e){
                e.preventDefault();
            });
            
            $('.page-panel a').on('mousedown',function(e){
                var action = $(this).data('action');
                 startAction(action);
            });
            
            $('.page-panel a').on('mouseup',function(e){
                var action = $(this).data('action');
                stopAction(action);
            });
            
            
            
            $('body').keydown(function(e){
                var key = e.which;
                var action;
                switch(key){
                    case 55: case 103: action="turn-forward-left"; break;
                    case 56: case 104: action="move-forward"; break;
                    case 57: case 105: action="turn-forward-right"; break;
                    case 52: case 100: action="rotate-left"; break;
                    case 53: case 101: action="move-backward"; break; 
                    case 54: case 102: action="rotate-right"; break;
                    case 49: case 97: action="turn-backward-left"; break;
                    case 50: case 98: action="move-backward"; break;                    
                    case 51: case 99: action="turn-backward-right"; break;
                }              
                startAction(action);
            });
            
            $('body').keyup(function(e){
                var key = e.which;
                var action;
                switch(key){
                    case 103: action="turn-forward-left"; break;
                    case 104: action="move-forward"; break;
                    case 105: action="turn-forward-right"; break;
                    case 100: action="rotate-left"; break;
                    case 101: action="move-backward"; break; 
                    case 102: action="rotate-right"; break;                        
                    case 97: action="turn-backward-left"; break;
                    case 98: action="move-backward"; break;                    
                    case 99: action="turn-backward-right"; break;
                }
                
                stopAction(action);
            });
            
            // do things               
            
            

        }

        



        /**
         *
         * Functions

         *
         */
        function startAction(action){
            if(active_actions[action]==true)
                    return;
            
            console.log("send start: "+action);
            connection.command.send(JSON.stringify( {"action":action} ));
            active_actions[action] = true;
        }
        
        function stopAction(action){
            console.log("send stop: "+action); 
            connection.command.send(JSON.stringify( {"stop":action} ));
            active_actions[action] = false;
        }
        
        /*
         * 
         */
        function connectToCommandServer(){
            connection.command = new WebSocket("ws://"+options.setup.cmdServer.host+":"+options.setup.cmdServer.port);
            
            connection.command.onopen = function () {
                console.log('Command Server Opened');
                $('#btnConnect').hide();
                $('#btnDisconnect').show();
                $(target).css({opacity:1});
            };
            
            connection.command.onerror = function (error) {
                $('#btnConnect').show();
                $('#btnDisconnect').hide();
                console.log('Command Server Error ' + error);
            };
            
            connection.command.onclose = function(e){
                $('#btnConnect').show();
                $('#btnDisconnect').hide();
                console.log('Command Server Closed');
            };
            
            // Log messages from the server
            connection.command.onmessage = function (e) {
              //console.log('Command Server: ' + e.data);
              processCommandServer(e.data);
            };
        }
        
        /*
         * 
         */
        function closeCommandServer(){
            connection.command.close();
        }
        
        /*
         * 
         */
        function processCommandServer(response){
            var data = $.parseJSON(response);
            
            

        }
        

                
        /*
         * 
         */
        function assumeSettings() {
            $.extend(true, options, options.data.settings);
        }

        
        /*
         * 
         */
        function getTemplate(template,replace){
            var output;
            
            $.ajax( { url: template, 
                async       : false,
                dataType    : 'html',
                success     : function(data) {
                    output = data;
                    for(var key in replace){
                        output = output.replace(new RegExp('###'+key+'###','gi'),replace[key]);
                    }
                }
            });
            
            return output;
        }
        
        



        /**
         * the end
         */
        run(options);
        



        return {
            
            // some mapped functions to call from outside
            init    : run
        };
        
        
        
    };

})(jQuery);

