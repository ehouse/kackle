############################### 
# Minify passed in file path
#
# Arguments:
#   String of file path
###############################
_config_minimize_files="true"

minify::file() {
    #if (( "$_config_minimize_files" )) && [[ -f $1 ]];then
    if [[ -f $1 ]] && [[ $_config_minimize_files ]];then
         cat $1 \
            | perl -w -mHTML::Packer -e '$packer=HTML::Packer->init();$_=do{local $/;<STDIN>};$_=$packer->minify(\$_,{remove_newlines=>"true",remove_comments=>"true",do_stylesheet=>"true"});print $_;'\
            | tee $1 > /dev/null
    fi
}
