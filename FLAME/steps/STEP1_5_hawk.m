function [output, hawk_avg] = STEP1_5_hawk(input, hawk_option)
if hawk_option == 1
levels = 3;
neg_mode = 'Separate';
group_by_time = true;

    [height, width, num_volumes, ~,] = size(input);
    
    for i = 1:num_volumes
        current_volume = squeeze(input(:,:,i,:));
        [~, ~, num_frames] = size(current_volume);
        output_cells = cell(1, num_frames);
        frame_counts = zeros(1, num_frames);
        
        % Precompute kernel parameters
        kernel_widths = 2.^(1:levels);
        half_widths = 2.^(0:levels-1);
        
        for l = 1:levels
            kernel_width = kernel_widths(l);
            half_width = half_widths(l);
            valid_frames = num_frames - kernel_width + 1;
            
            % Vectorized frame processing
            for s = 1:valid_frames
                kernel_frames = current_volume(:,:,s:s+kernel_width-1);
                front_part = sum(kernel_frames(:,:,1:half_width), 3);
                back_part = sum(kernel_frames(:,:,half_width+1:end), 3);
                diff = front_part - back_part;
                
                center_pos = s + half_width - 1;
                if strcmpi(neg_mode, 'abs')
                    pos_frame = abs(diff);
                    neg_frame = [];
                else
                    pos_frame = max(diff, 0);
                    neg_frame = max(-diff, 0);
                end
                
                if group_by_time
                    if isempty(output_cells{center_pos})
                        output_cells{center_pos} = struct('pos', pos_frame, 'neg', neg_frame);
                    else
                        output_cells{center_pos}(end+1) = struct('pos', pos_frame, 'neg', neg_frame);
                    end
                    frame_counts(center_pos) = frame_counts(center_pos) + 1;
                else
                    output_cells{end+1} = struct('pos', pos_frame, 'neg', neg_frame);
                end
            end
        end
        
        % Process output for current volume
        valid_indices = find(frame_counts > 0);
        total_frames = sum(frame_counts(valid_indices)) * (1 + strcmpi(neg_mode, 'separate'));
        volume_output = zeros(height, width, total_frames, 'like', input);
        
        idx = 1;
        for k = valid_indices
            frames = output_cells{k};
            for j = 1:length(frames)
                volume_output(:,:,idx) = frames(j).pos;
                idx = idx + 1;
                if ~isempty(frames(j).neg)
                    volume_output(:,:,idx) = frames(j).neg;
                    idx = idx + 1;
                end
            end
        end
        
        % Add noise and store
        volume_output(1,1,:) = volume_output(1,1,:) + eps;
        output(:,:,:,i) = volume_output;
    end
    output = permute(output,[1 2 4 3]);
else
    output = input;
end
    hawk_avg = mean(output,4);
end