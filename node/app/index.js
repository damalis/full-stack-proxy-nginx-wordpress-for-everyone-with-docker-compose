const imagemin = require('imagemin');
const imageminJpegtran = require('imagemin-mozjpeg');
const imageminPngquant = require('imagemin-pngquant');
const moveFile = require('move-file');

var argv = require('minimist')(process.argv.slice(2));

(async () => {
	//const files = await imagemin(['images/*.{jpg,png,JPG,gif,jpeg,JPEG}'], {
	const files = await imagemin([argv.image], {
		destination: argv.tmp,
		plugins: [
			imageminJpegtran(),
			imageminPngquant({
				quality: [0.6, 0.8]
			})
		]
	});
	
	if (typeof files !== 'undefined' && files.length > 0) {		
    	files.forEach(async (element) => { 
    		await moveFile(element['destinationPath'], element['sourcePath'], {overwrite: true});
        	//console.log('The file has been moved');
        });    	
    }

	//console.log(files[0]['sourcePath']);
})();
