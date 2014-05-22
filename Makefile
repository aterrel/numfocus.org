PY=python
HYDE=hyde
HYDEOPTS=
GHPIMPORT=ghp-import

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/deploy
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

FTP_HOST=localhost
FTP_USER=anonymous
FTP_TARGET_DIR=/

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

TOP_LEVEL_DOMAIN?=numfocus.org

S3_BUCKET=my_s3_bucket

DROPBOX_DIR=~/Dropbox/Public/

# The github remote that the main website is hosted from
GITHUB_DEPLOY_REMOTE?=upstream

# The remote you'd like to push to
GITHUB_REMOTE?=$(GITHUB_DEPLOY_REMOTE)

# The github pages branch, should be either gh-pages or master
GITHUB_PAGES_BRANCH?=gh-pages

help:
	@echo 'Makefile for a NumFOCUS Web site                                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        (re)generate the web site          '
	@echo '   make clean                       remove the generated files         '
	@echo '   make regenerate                  regenerate files upon modification '
	@echo '   make serve                       serve site at http://localhost:8000'
	@echo '   github                           upload the web site via gh-pages   '
	@echo '                                                                       '


html: clean $(OUTPUTDIR)/index.html

$(OUTPUTDIR)/%.html:
	$(HYDE) gen

clean:
	[ ! -d $(OUTPUTDIR) ] || find $(OUTPUTDIR) -mindepth 1 -delete

regenerate: clean
	$(HYDE) gen -regen

serve:
	$(HYDE) serve

devserver:
	$(BASEDIR)/develop_server.sh restart

github: regenerate
	test "$(GITHUB_REMOTE)" = "$(GITHUB_DEPLOY_REMOTE)" && (echo "$(TOP_LEVEL_DOMAIN)" > $(OUTPUTDIR)/CNAME) || echo "CNAME file not made, GITHUB_REMOTE != GITHUB_DEPLOY_REMOTE"
	$(GHPIMPORT) $(OUTPUTDIR) 
	git push -f $(GITHUB_REMOTE) $(GITHUB_PAGES_BRANCH) 

.PHONY: html help clean regenerate serve github
