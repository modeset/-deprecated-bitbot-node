SimpleResponder = require '../simple_responder'

responses       = [ 'http://desmond.yfrog.com/Himg644/scaled.php?tn=0&server=644&xsize=640&ysize=640&filename=xopxd.jpg',
                    'http://s3-ec.buzzfed.com/static/enhanced/webdr02/2013/7/9/10/anigif_enhanced-buzz-6459-1373380601-19.gif' ]
regex           = /fuck that|broke|bull(\s?)shit|fuck(\s?)all|crap|damn it|dammit/
module.exports  = new SimpleResponder(regex, responses)
