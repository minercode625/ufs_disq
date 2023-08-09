% get result of feature selction
clear;

data_dir = './data/';
% list of data which name has '.mat'
data_list = dir([data_dir, '*.mat']);
data_list = {data_list.name};

fs_dir = './result/';
fs_list = dir([fs_dir, '*.mat']);
fs_list = {fs_list.name};

save_dir = './result_fs/';


rep_size = 10;
max_fs_size = 100;
pctRunOnAll warning('off');
%for k = 1:6
for k = 7:length(fs_list)
    k
    load(data_list{k});
    data_name = data_list{k}(1:end-4);
    load(strcat(data_name, '_exp.mat'));
    [~, col] = size(fea);
    max_col = min(max_fs_size, col);
    fs_size = 10:10:max_col;
    res = struct('alg', {}, 'acc', {}, 'acc_std', {},...
        'nmi', {}, 'nmi_std', {}, 'c', {}, 'c_std', {}, ...
        'ffei', {}, 'sil', {}, 'sil_std', {}, 'dbi', {}, 'dbi_std', {}, ...
        'ent', {}, 'nmi_s', {}, 'pur', {}, 'pur_std', {});
    for alg_idx = 1:length(param_struct)
        alg = param_struct(alg_idx).alg;
        param = param_struct(alg_idx).param;
        sil_table = zeros(length(param), length(fs_size));
        dbi_table = zeros(length(param), length(fs_size));
        sil_std_table = zeros(length(param), length(fs_size));
        dbi_std_table = zeros(length(param), length(fs_size));
        acc_table = zeros(length(param), length(fs_size));
        acc_std_table = zeros(length(param), length(fs_size));
        nmi_table = zeros(length(param), length(fs_size));
        nmi_std_table = zeros(length(param), length(fs_size));
        c_table = zeros(length(param), length(fs_size));
        c_std_table = zeros(length(param), length(fs_size));
        ffei_table = zeros(length(param), length(fs_size));
        ent_table = zeros(length(param), length(fs_size));
        nmi_s_table = zeros(length(param), length(fs_size));
        pur_table = zeros(length(param), length(fs_size));
        pur_std_table = zeros(length(param), length(fs_size));
        for param_idx = 1:length(param)
            fs_list = param_struct(alg_idx).fea;
            f_sel = fs_list(param_idx,:);
            parfor fs_idx = 1:length(fs_size)
                fs = fs_size(fs_idx);
                X_fs = fea(:, f_sel(1:fs));
                eval_res = dhc(X_fs, gnd, fea);
                sil = eval_res.sil;
                dbi = eval_res.dbi;
                acc = eval_res.acc;
                nmi = eval_res.nmi;
                pur = eval_res.pur;
                c = eval_res.c;
                ffei_res = eval_res.ffei;
                ent_res = eval_res.ent;
                nmi_s_res = eval_res.nmi_s;
                acc_table(param_idx, fs_idx) = acc(1,1);
                acc_std_table(param_idx, fs_idx) = acc(1,2);
                nmi_table(param_idx, fs_idx) = nmi(1,1);
                nmi_std_table(param_idx, fs_idx) = nmi(1,2);
                c_table(param_idx, fs_idx) = c(1,1);
                c_std_table(param_idx, fs_idx) = c(1,2);
                ffei_table(param_idx, fs_idx) = ffei_res(1,1);
                ent_table(param_idx, fs_idx) = ent_res(1,1);
                nmi_s_table(param_idx, fs_idx) = nmi_s_res(1,1);
                sil_table(param_idx, fs_idx) = sil(1,1);
                sil_std_table(param_idx, fs_idx) = sil(1,2);
                dbi_table(param_idx, fs_idx) = dbi(1,1);
                dbi_std_table(param_idx, fs_idx) = dbi(1,2);
                pur_table(param_idx, fs_idx) = pur(1,1);
                pur_std_table(param_idx, fs_idx) = pur(1,2);
            end
        end
        res(alg_idx).alg = alg;
        res(alg_idx).sil = sil_table;
        res(alg_idx).sil_std = sil_std_table;
        res(alg_idx).dbi = dbi_table;
        res(alg_idx).dbi_std = dbi_std_table;
        res(alg_idx).acc = acc_table;
        res(alg_idx).acc_std = acc_std_table;
        res(alg_idx).nmi = nmi_table;
        res(alg_idx).nmi_std = nmi_std_table;
        res(alg_idx).c = c_table;
        res(alg_idx).c_std = c_std_table;
        res(alg_idx).ffei = ffei_table;
        res(alg_idx).ent = ent_table;
        res(alg_idx).nmi_s = nmi_s_table;
        res(alg_idx).pur = pur_table;
        res(alg_idx).pur_std = pur_std_table;
    end
    save_name = strcat(save_dir, data_name, '_fs.mat');
    save(save_name, 'res');
end
