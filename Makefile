.PHONY: examples docker docker-build

CC = xelatex
EXAMPLES_DIR = examples
RESUME_DIR = examples/resume
CV_DIR = examples/cv
RESUME_SRCS = $(shell find $(RESUME_DIR) -name '*.tex')
CV_SRCS = $(shell find $(CV_DIR) -name '*.tex')
DOCKER_IMAGE = aachraf/latex-cv-docker

examples: $(foreach x, coverletter cv resume, $x.pdf)

resume.pdf: $(EXAMPLES_DIR)/resume.tex $(RESUME_SRCS)
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

cv.pdf: $(EXAMPLES_DIR)/cv.tex $(CV_SRCS)
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

coverletter.pdf: $(EXAMPLES_DIR)/coverletter.tex
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

docker-build:
	docker build -t $(DOCKER_IMAGE) .

docker-resume: docker-build
	docker run --rm --user $(shell id -u):$(shell id -g) -i -w "/doc" -v "$(PWD)":/doc $(DOCKER_IMAGE) make resume.pdf

docker-cv: docker-build
	docker run --rm --user $(shell id -u):$(shell id -g) -i -w "/doc" -v "$(PWD)":/doc $(DOCKER_IMAGE) make cv.pdf

docker-coverletter: docker-build
	docker run --rm --user $(shell id -u):$(shell id -g) -i -w "/doc" -v "$(PWD)":/doc $(DOCKER_IMAGE) make coverletter.pdf

docker: docker-build
	docker run --rm --user $(shell id -u):$(shell id -g) -i -w "/doc" -v "$(PWD)":/doc $(DOCKER_IMAGE)

clean:
	rm -rf $(EXAMPLES_DIR)/*.pdf
