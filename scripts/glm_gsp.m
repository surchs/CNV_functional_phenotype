clear;


root_path = '/project/6003287/PROJECT/GSP_all/';
preproc_path = [root_path 'preproc/'];
%preproc_path = '/home/cmoreau/projects/def-pbellec/Simons_VIP/GSP_all/prep_out/';
path_out = [root_path 'glm/main_effect_noTIV_50_withFD'] ;
model_path = [root_path 'pheno/DataRelease_2014_underscore_FD.csv'];


files_in.networks.cambridge64 = [root_path 'template/template_cambridge_basc_multiscale_sym_scale064.nii.gz'];
files_in.networks.cambridge36 = [root_path 'template/template_cambridge_basc_multiscale_sym_scale036.nii.gz'];

opt_g.exclude_subject = {'Sub0105xSes1', 'Sub0133xSes1' , 'Sub0246xSes1' , 'Sub0730xSes1' 'Sub0816xSex1' , 'Sub0855xSex1', 'Sub0857xSex1','Sub0980xSex1' ,'Sub1118xSex1' 'Sub1179xSex1', 'Sub1326xSex1' , 'Sub1339xSex1' , 'Sub1345xSex1' , 'Sub1387xSex1', 'Sub1388xSex1', 'Sub1408xSex1' , 'Sub1474xSex1', 'Sub1487xSex1' , 'Sub1496xSex1'};
%opt_g.exclude_subject = {'Sub0105Ses1', 'Sub0133Ses1' , 'Sub0246Ses1' , 'Sub0730Ses1' 'Sub0816Ses1' , 'Sub0855Ses1', 'Sub0857Ses1','Sub0980Ses1' ,'Sub1118Ses1' 'Sub1179Ses1', 'Sub1326Ses1' , 'Sub1339Ses1' , 'Sub1345Ses1' , 'Sub1387Ses1', 'Sub1388Ses1', 'Sub1408Ses1' , 'Sub1474Ses1', 'Sub1487Ses1' , 'Sub1496Ses1'};

opt_g.min_nb_vol = 50; % The minimum number of volumes for an fMRI dataset to be included. This option is useful when scrubbing is used, and the resulting time series may be too short.
opt_g.min_xcorr_func = 0.5; % The minimum xcorr score for an fMRI dataset to be included. This metric is a tool for quality control which assess the quality of non-linear coregistration of functional images in stereotaxic space. Manual inspection of the values during QC is necessary to properly set this threshold.
opt_g.min_xcorr_anat = 0.5; % The minimum xcorr score for an fMRI dataset to be included. This metric is a tool for quality control which assess the quality of non-linear coregistration of the anatomical image in stereotaxic space. Manual inspection of the values during QC is necessary to properly set this threshold.
opt_g.type_files = 'glm_connectome'; % Specify to the grabber to prepare the files for the glm_connectome pipeline
tmp =  niak_grab_fmri_preprocess(preproc_path, opt_g);
files_in.fmri = tmp.fmri;
files_in.model.group = model_path;

opt.fdr = 0.05;
opt.folder_out = path_out; % Where to store the results

%%%%%%%%%%% add your model (same as the one for the subtype) %%%%%%%%%%%%%%


%% Tests
%%%%%%%%%%%%

%%%% mean BV  %%%%%
opt.test.mean_BV.group.contrast.sex_dummy = 0;
opt.test.mean_BV.group.contrast.BrainSegVol_norm = 1;
opt.test.mean_BV.group.contrast.age_norm = 0;
opt.test.mean_BV.group.contrast.FD_scrubbed_s1_s2_norm = 0;
opt.test.mean_BV.group.flag_intercept = true;
opt.test.mean_BV.group.normalize_x = false;
opt.test.mean_BV.group.normalize_y = true;
opt.test.mean_BV.group.normalize_type = 'mean_var';

%%%% mean Age %%%%%
opt.test.mean_age.group.contrast.sex_dummy = 0;
opt.test.mean_age.group.contrast.BrainSegVol_norm = 0;
opt.test.mean_age.group.contrast.FD_scrubbed_s1_s2_norm= 0;
opt.test.mean_age.group.contrast.age_norm = 1;
opt.test.mean_age.group.flag_intercept = true;
opt.test.mean_age.group.normalize_x = false;
opt.test.mean_age.group.normalize_y = true;
opt.test.mean_age.group.normalize_type = 'mean_var';

%%%% mean FD %%%%%
opt.test.mean_fd.group.contrast.sex_dummy = 0;
opt.test.mean_age.group.contrast.BrainSegVol_norm = 0;
opt.test.mean_fd.group.contrast.FD_scrubbed_s1_s2_norm= 1;
opt.test.mean_fd.group.contrast.age_norm = 0;
opt.test.mean_fd.group.flag_intercept = true;
opt.test.mean_fd.group.normalize_x = false;
opt.test.mean_fd.group.normalize_y = true;
opt.test.mean_fd.group.normalize_type = 'mean_var';


opt.flag_test = false; 
opt.psom.max_queued = 20;
opt.psom.qsub_options = '--mem=8G  --account rrg-pbellec --time=00-4:00  --ntasks=1 --cpus-per-task=2';
[pipeline,opt] = niak_pipeline_glm_connectome(files_in,opt);





