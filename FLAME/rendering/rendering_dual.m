function rendering2(input1,input2,input3,input4)
load (['Lut/flame-orange.lut']);
load (['Lut/flame-blue.lut']);
load (['Lut/flame_b_o.lut'])
load (['Lut/ipic-phase.lut']);

flame_b_o = flame_b_o./max(max(flame_b_o));
ipic_phase = ipic_phase./max(max(ipic_phase));


input1T = flipud(permute(input1, [3 2 1]));
input2T = flipud(permute(input2, [3 2 1]));
input3T = flipud(permute(input3, [3 2 1]));
input4T = flipud(permute(input4, [3 2 1]));
input4T = input4T./max(max(max(input4T)));

T1_n = max(input1T,[],3);
T1_p = max(input2T,[],3);
T1_speed = max(input3T,[],3);
T1_CEUS = max(input4T,[],3);
sigma = 1;
T1_CEUS = imgaussfilt(T1_CEUS, sigma);

T1_n = T1_n.^0.7;
T1_p = T1_p.^0.7;
T1_n(T1_n<T1_p) = 0;
T1_n = abs(T1_n); 
T1_p(T1_p<T1_n) = 0;
T1_p = abs(T1_p); 

T1_n = -T1_n./2+0.5;
T1_p = T1_p./2+0.5;
T1_x = T1_n + T1_p;

T1_speed = T1_speed.^0.5;

T1_CEUS = percennorm(T1_CEUS);
T1_x = percennorm(T1_x);
T1_speed = percennorm(T1_speed);

figure; % 
set(gcf, 'Units', 'normalized', 'Position', [0.2, 0.3, 0.6, 0.4]); % 
subplot(1,3,1);imshow(T1_CEUS,[],'Colormap', gray,'InitialMagnification',100);title('Raw');colorbar('southoutside');
subplot(1,3,2);imshow(T1_x,[],'Colormap', flame_b_o,'InitialMagnification',100);title('FLAME-intensity');colorbar('southoutside');
subplot(1,3,3);imshow(T1_speed,[],'Colormap', ipic_phase,'InitialMagnification',100);title('FLAME-speed');colorbar('southoutside');

end




