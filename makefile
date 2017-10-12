all:
	rm -rf docs
	reveal-md slides.md --css assets/custom.css --static docs
	
clean:
	rm -rf docs