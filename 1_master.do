** ================================================================================================
** Project:         Lancet Public health - nowcasting and forecasting the care needs of the older population in China 
** Aim:             Set up global macro for paths
** Author:          CHARLS team
** Created:         2020/20/14
** Modified:        2023/3/27
** ==============================================================================================
//Please set up a folder in your pc. raw_data, working_data, out_data, do_files, figures and tables are subfolders. In this do file, path for this folder is "path" (a global macro)

//charls_20**r are folders for CHARLS public data. 

//Path for charls_2011r folder is "charls_2011r" (a global macro). Path for charls_2013r folder is "charls_2013r" (a global macro). Path for charls_2015r folder is "charls_2015r" (a global macro). Path for charls_2020r folder is "charls_2020r" (a global macro).

//Path for CHARLS variables set which are constructed by CHARLS team in CHARLS server is "charls_variable_set" (a global macro). Not in public data

//charls_figure2excel is the ado constructed by CHARLS team

clear
set scheme charls

global path "path for this project, such as D:\disability" //update by yourself

global CHARLS_2011r "..\CHARLS2011r" //update by yourself
global CHARLS_2013r "..\CHARLS2013r" //update by yourself
global CHARLS_2015r "..\CHARLS2015r" //update by yourself
global CHARLS_2018r "..\CHARLS2018r" //update by yourself
global CHARLS_2020r "..\CHARLS2020r" //update by yourself

global charls_variable_set "..\CHARLS_Private\CHARLS_Variable_Set"

global raw_data $path/raw_data
global working_data $path/working_data
global out_data $path/out_data
global do_files $path/do_files
global figures $path/figures
global tables $path/tables
