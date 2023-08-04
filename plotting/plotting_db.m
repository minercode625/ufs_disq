clear;
% Make line plot
% 6 8 9 11
for idx = 1: 6
  cer_idx = 11;
  alg_idx = 1;
  load('total_res_mean.mat');
  alg_list = [3, 4, 7, 9 ,12];
  data_list = [2, 4, 5, 7 , 9, 10];
  dat_list = {'BA', 'COIL20', 'colon', 'Isolet', 'Leukemia', 'lung', 'Lymphoma', 'madeleon', 'ORL', 'ORL64', 'TOX-171', 'UMIST', 'USPS', 'YaleB'};
  tar_data = data_list(idx);
  data_name = dat_list{tar_data};
  y = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  
  line_style = {'-o', '-s', '-^', '-d', '-v'};
  line_sytle2 = {'--o', '-s', '--^', '--d', '-v'};
  line_color = {'k', 'k', 'k', 'k', 'b'};
  line_color2 = {'c', 'k', 'c', 'c', 'b'};
  data_size = size(res_mat, 2);
  
  
  
  max_cell = struct2cell(res_mat);

  max_cell = max_cell(:, :, tar_data);

  max_mat = max_cell{cer_idx, 1};

  max_mat = max_mat(alg_list, :);

  max_val = max(max(max_mat));
  min_val = min(min(max_mat));
  for i = 1:length(alg_list)
    plot(y, max_mat(i, :), line_style{i}, 'Color', line_color{i}, 'LineWidth', 2, 'MarkerSize', 8);
    hold on;
  end
  
  set(gca, 'LooseInset', get(gca, 'TightInset'));
  set(gca, 'FontName', 'Times New Roman');
  % Set axis
  % Set label
  set(gca, 'XTick', [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]);
  xlim([5, 110]);
  ylim([min_val, max_val]);
  % Set label name
  xlabel('Number of selected features', 'FontSize', 18);
  ylabel('Davis-Bouldin score', 'FontSize', 18);
  
  % Set legend
  legend('CNAFS', 'UDFS','EGCFS','SOCFS', 'Proposed', 'Location', 'northeast');
  
  % Save figure eps format
  saveas(gcf, ['./db_', data_name, '.eps'], 'epsc');
  
  % reset figure
  clf;
end







