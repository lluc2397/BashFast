#Local machine
create_new_alias (){
	NAME="$1"
	DO="$2"
	echo "alias $NAME='$DO'" >> $PWD/".bash_alias"
	echo "Alias $1 created, refreshing alias"
	ra
	echo "New alias ready"
}

list_process (){
	NAME="$1"
	ps -C "$NAME" -f
}

delete_alias (){
	ALIAS="$1"
	sed -i "/\b\($ALIAS\)\b/d" $PWD/".bash_alias"
	echo "Alias $NAME deleted, refreshing alias"
	ra
	echo "Alias ready"
}

create_enter_dir (){
	mkdir -p $1
	cd $1
}

copy_with_rsync (){
	FROM="$1"
	TO="${2:-.}"
	rsync -chavzP --stats --progress "$FROM" "$TO"
}

copy_with_tar (){
	FROM="$1"
	TO="${2:-.}"
	tar cf - "$FROM" | tar xvf - -C "$TO"
}

extract_tgz (){
	FILE="$1"
        TO="${2:-.}"
	tar -xzvf "$FILE" -C "$TO"
}

count_files_inside (){
	FOLDER="${1:-.}"
	ls "$FOLDER" | wc -l
}

#SSH
_create_ssh_key (){
	NAME="$1"
	ssh-keygen -f ~/.ssh/"$NAME" -t ecdsa -b 521
}

_send_ssh_key (){
	NAME="$1"
	USER="$2"
	ssh-copy-id -i ~/.ssh/"$NAME".pub "$USER"
}

_show_ssh_key (){
	NAME="$1"
	cat ~/.ssh/"$NAME"
}



#Venv
create_activate_enter_venv () {
	VENV_NAME="${1:-venv}"
	venv "$VENV_NAME"
	source "$VENV_NAME"/bin/activate;
	cd $PWD"/"$VENV_NAME
}

# Jupyter
venv_jupyter () {
	VENV_NAME="${1:-venv}"
	venv "$VENV_NAME"
	source "$VENV_NAME"/bin/activate;
	pip install ipykernel
	ipython kernel install --user --name="$VENV_NAME"
	pip install pandas numpy seaborn matplotlib plotly openpyxl
}

new_jupyter_file () {
	FILE_NAME="${1:-brain}"
	touch "$FILE_NAME".ipynb
}

new_jupyter_project () {
	FOLDER_NAME="${2}"
	FILE_NAME="${3:-brain}"
	FULL_PATH="/mnt/74089228-1bc4-44ce-ad9b-82150245119f/AI/$FOLDER_NAME"
	cd $FULL_PATH
	venv_jupyter;
	NEW_FILE="$FILE_NAME".ipynb
	touch "$NEW_FILE"  
	echo "import matplotlib.pyplot as plt">> "$FULL_PATH/$NEW_FILE"
	echo "import seaborn as sns">> "$FULL_PATH/$NEW_FILE"
	echo "import pandas as pd">> "$FULL_PATH/$NEW_FILE"
	echo "import numpy as np">> "$FULL_PATH/$NEW_FILE"
	echo "import matplotlib">> "$FULL_PATH/$NEW_FILE"
	echo "import plotly.express as px">> "$FULL_PATH/$NEW_FILE"
}

#Docker
docker_compose_up (){
        FROM_FILE="${1:-local.yml}"
        docker-compose -f "$FROM_FILE" up
}

docker_compose_run_django (){
	FROM_FILE="${1:-local.yml}"
        COMMAND="$2"
	docker-compose -f "$FROM_FILE" run --rm django python manage.py "$2"
}


#Git
current_git_branch() {
 ref=$(git symbolic-ref HEAD | cut -d'/' -f3)
 echo $ref
}

git_save_all (){
	COMMIT_MESSAGE="${1:-.}"
	REPO="${2:-origin}"
	CURRENT_BRANCH=$(current_git_branch)
	BRANCH="${3:-$CURRENT_BRANCH}"
	git add .
	git commit -m "$COMMIT_MESSAGE"
	git push "$REPO" "$BRANCH"
}

git_save_dev (){
	COMMIT_MESSAGE="${1:-.}"
	CURRENT_BRANCH=$(current_git_branch)
	BRANCH="${2:-$CURRENT_BRANCH}"
	git add .
	git commit -m "$COMMIT_MESSAGE"
	git push "origin" "$BRANCH"
	git push "gitlab" "$BRANCH"
	git push "bitbucket" "$BRANCH"
}

git_send_web (){
	COMMIT_MESSAGE="${1:-.}"
	CURRENT_BRANCH=$(current_git_branch)
	BRANCH="${2:-$CURRENT_BRANCH}"
	git add .
	git commit -m "$COMMIT_MESSAGE"
	git push "origin" "$BRANCH"
	git push "gitlab" "$BRANCH"
	git push "bitbucket" "$BRANCH"
	git push "prod" "$BRANCH"
}

#Django
delete_all_migrations () {
	find . -path "*/migrations/*.py"  -not -path "*/contrib/sites/migrations/*.py" -not -name "__init__.py" -delete
	find . -path "*/migrations/*.pyc"  -delete
}

run_django_tests () {
	TEST="$1"
	dtest "$TEST" --settings config.settings.test --keepdb
}

create_new_django_app () {
	APP_NAME="$1"
	manage startapp "$APP_NAME"
}
