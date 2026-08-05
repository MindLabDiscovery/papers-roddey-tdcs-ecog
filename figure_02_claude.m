path = "/home/roddeyt/Documents"
%% cfg 

data.cfg.info.n_sbj='26';
data.cfg.info.i_chan=[1 2 3 4 5 6];
data.cfg.info.dx='pd';
data.cfg.info.Fs=1000;
data.cfg.trial_data.t1.filename = path + "/pro00073545_0026/ecog/VRP_26-210223-160648"
% freq bands
frq_band_txt{1}='delta';
frq_band_txt{2}='theta';
frq_band_txt{3}='alpha';
frq_band_txt{4}='beta';
frq_band_txt{5}='gamma';
frq_band_txt{6}='gamma_l';
frq_band_txt{7}='gamma_bb';

frq_band_ind{1}=['2:3'];
frq_band_ind{2}=['3:5'];
frq_band_ind{3}=['5:7'];
frq_band_ind{4}=['8:16'];
frq_band_ind{5}=['16:206'];
frq_band_ind{6}=['16:27'];
frq_band_ind{7}=['28:103'];


% filters
[n2_b, n2_a]=butter(3,2*[117 123]/data.cfg.info.Fs,'stop');%120 Hz
[n3_b, n3_a]=butter(3,2*[177 183]/data.cfg.info.Fs,'stop');%180 Hz

% parse trials
names_trial_num=regexp(fieldnames(data.cfg.trial_data),'[0-9]','match');
for i=1:size(names_trial_num,1)
    n_trial(i)=str2double(names_trial_num{i});
end

% resample and filter signals
% for i=1:size(n_trial,2)
%     eval(['temp.t',num2str(i)','.sig.all=TDTbin2mat(data.cfg.trial_data.t',num2str(i),'.filename);'])
%     eval(['temp.t',num2str(i),'.sig.trig=resample(double(temp.t',num2str(i),'.sig.all.streams.Trig.data)'',2^10,5^5);'])
%     eval(['temp.t',num2str(i),'.sig.ecog=filtfilt(n3_b,n3_a,filtfilt(n2_b,n2_a,resample(double(temp.t',num2str(i),'.sig.all.streams.ECOG.data)'',2^10,5^5)));'])
%     eval(['temp.t',num2str(i),'.sig.amps=resample(double(temp.t',num2str(i),'.sig.all.streams.amps.data)'',2^10,5^5);'])
%     eval(['temp.t',num2str(i),'.sig.sync=resample(double(temp.t',num2str(i),'.sig.all.streams.Sync.data)'',2^10,5^5);'])
% end

for i=1:size(n_trial,2)
    eval(['temp.t',num2str(i)','.sig.all=TDTbin2mat(char(data.cfg.trial_data.t',num2str(i),'.filename));'])
    eval(['temp.t',num2str(i),'.sig.trig=resample(double(temp.t',num2str(i),'.sig.all.streams.Trig.data)'',2^10,5^5);'])
    eval(['temp.t',num2str(i),'.sig.ecog=filtfilt(n3_b,n3_a,filtfilt(n2_b,n2_a,resample(double(temp.t',num2str(i),'.sig.all.streams.ECOG.data)'',2^10,5^5)));'])
    eval(['temp.t',num2str(i),'.sig.amps=resample(double(temp.t',num2str(i),'.sig.all.streams.amps.data)'',2^10,5^5);'])
    eval(['temp.t',num2str(i),'.sig.sync=resample(double(temp.t',num2str(i),'.sig.all.streams.Sync.data)'',2^10,5^5);'])
    %eval(['temp.t',num2str(i),'.sig.beta=resample(double(temp.t',num2str(i),'.sig.all.streams.Beta.data)'',2^10,5^5);'])
    %eval(['temp.t',num2str(i),'.sig.gamma=resample(double(temp.t',num2str(i),'.sig.all.streams.Gamm.data)'',2^10,5^5);'])

end

figure;% plot(temp.t1.sig.beta)
set(gca,'ylim',[-6e-11 6e-10])
%hold on; plot(temp.t1.sig.gamma*1e2)
hold on; plot(temp.t1.sig.ecog(:,1)/1e7)
plot(temp.t1.sig.ecog(:,2)/1e7+1e-10)
plot(temp.t1.sig.ecog(:,3)/1e7+2e-10)
plot(temp.t1.sig.ecog(:,4)/1e7+3e-10)
plot(temp.t1.sig.ecog(:,5)/1e7+4e-10)
plot(temp.t1.sig.ecog(:,6)/1e7+5e-10)



for i=1:size(n_trial,2)
    eval(['data.trials.t',num2str(i),'.sig.trig=temp.t',num2str(i),'.sig.trig'])
    eval(['data.trials.t',num2str(i),'.sig.ecog=temp.t',num2str(i),'.sig.ecog'])
    eval(['data.trials.t',num2str(i),'.sig.amps=temp.t',num2str(i),'.sig.amps'])
    eval(['data.trials.t',num2str(i),'.sig.sync=temp.t',num2str(i),'.sig.sync'])
end


%plot data (unscaled)
for i=1:size(n_trial,2)
    for j=1:size(data.cfg.info.i_chan,2)
        if j==1
            figure
        end
        eval(['plot(data.trials.t',num2str(i),'.sig.ecog(:,',num2str(j),')*10+j*1e-2)']); hold on
    end
    eval(['plot(data.trials.t',num2str(i),'.sig.sync(:,1))']);
    eval(['plot(data.trials.t',num2str(i),'.sig.trig(:,1))']);
    %eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1))']);
    legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','sync','trig','amps')
    %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
end

data.trials.t1.epochs.e1(1,1)=1.03e5; %No stim Pre Move
data.trials.t1.epochs.e1(1,2)=1.29e5;
data.trials.t1.epochs.e2(1,1)=1.63e5; %No stim RA Flex
data.trials.t1.epochs.e2(1,2)=1.90e5;
data.trials.t1.epochs.e3(1,1)=1.90e5; %No stim LA Flex
data.trials.t1.epochs.e3(1,2)=2.17e5;
data.trials.t1.epochs.e4(1,1)=2.17e5; %No stim Post Move
data.trials.t1.epochs.e4(1,2)=2.37e5;
data.trials.t1.epochs.e5(1,1)=3.00e5; %2.0 Anodal Pre Move
data.trials.t1.epochs.e5(1,2)=3.40e5;
data.trials.t1.epochs.e6(1,1)=3.40e5; %2.0 Anodal RA Flex
data.trials.t1.epochs.e6(1,2)=3.64e5;
data.trials.t1.epochs.e7(1,1)=3.64e5; %2.0 mA Anodal LA Flex
data.trials.t1.epochs.e7(1,2)=3.88e5;
data.trials.t1.epochs.e8(1,1)=3.88e5; %2.0 mA Anodal Post Move
data.trials.t1.epochs.e8(1,2)=4.08e5;
data.trials.t1.epochs.e9(1,1)=4.56e5; %No stim (rest 2) Pre Move
data.trials.t1.epochs.e9(1,2)=4.96e5;
data.trials.t1.epochs.e10(1,1)=4.96e5; %No stim (rest 2) RA Flex
data.trials.t1.epochs.e10(1,2)=5.15e5;
data.trials.t1.epochs.e11(1,1)=5.15e5; %No stim (rest 2) LA Flex
data.trials.t1.epochs.e11(1,2)=5.34e5;
data.trials.t1.epochs.e12(1,1)=5.34e5; %No stim (rest 2) Post Move
data.trials.t1.epochs.e12(1,2)=5.54e5;
% data.trials.t1.epochs.e13(1,1)=6.71e5; %2.0 Cathodal Pre Move
% data.trials.t1.epochs.e13(1,2)=7.11e5;
% data.trials.t1.epochs.e14(1,1)=7.11e5; %2.0 Cathodal RA Flex
% data.trials.t1.epochs.e14(1,2)=7.32e5;
% data.trials.t1.epochs.e15(1,1)=7.32e5; %2.0 Cathodal LA Flex
% data.trials.t1.epochs.e15(1,2)=7.53e5;
% data.trials.t1.epochs.e16(1,1)=7.53e5; %2.0 Cathodal Post Move
% data.trials.t1.epochs.e16(1,2)=7.73e5;
% data.trials.t1.epochs.e17(1,1)=8.29e5; %No stim (rest 3) Pre Move
% data.trials.t1.epochs.e17(1,2)=8.69e5;
% data.trials.t1.epochs.e18(1,1)=8.69e5; %No stim (rest 3) RA Flex
% data.trials.t1.epochs.e18(1,2)=8.88e5;
% data.trials.t1.epochs.e19(1,1)=8.88e5; %No stim (rest 3) LA Flex
% data.trials.t1.epochs.e19(1,2)=9.07e5;
% data.trials.t1.epochs.e20(1,1)=9.07e5; %No stim (rest 3) Post Move
% data.trials.t1.epochs.e20(1,2)=9.27e5;



% parse epochs
for i=1:size(n_trial,2)
    names_epoch=fieldnames(data.trials);
end

for i=1:size(n_trial,2)
    num_epoch(i)=size(fieldnames(eval(['data.trials.',names_epoch{i},'.epochs'])),1);
end

mat_trial_epoch_sort=sortrows([n_trial;num_epoch]')
mat_trial_epoch=[(1:size(n_trial,2))',mat_trial_epoch_sort(:,1),mat_trial_epoch_sort(:,2)]

% plot data with epochs
pdfout = "Raw_Data_Figure.pdf"
for i=1:size(n_trial,2)
    for j=1:size(data.cfg.info.i_chan,2)
        if j==1
            fh1 = figure
            subplot(2,1,1)
        end
        eval(['plot(data.trials.t',num2str(i),'.sig.ecog(:,',num2str(j),')*10+j*1e-2)']); hold on
    end
    
    yplotlim=get(gca,'ylim');
    %eval(['plot(data.trials.t',num2str(i),'.sig.sync(:,1))']);
    eval(['plot(data.trials.t',num2str(i),'.sig.trig(:,1))']);
    eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1)/100)']);
    for k=1:12
        eval(['plot([data.trials.t',num2str(i),'.epochs.e',num2str(k),'(1) data.trials.t',num2str(i),'.epochs.e',num2str(k),'(1)],[yplotlim(1) yplotlim(2)],''g'')']);
        eval(['plot([data.trials.t',num2str(i),'.epochs.e',num2str(k),'(2) data.trials.t',num2str(i),'.epochs.e',num2str(k),'(2)],[yplotlim(1) yplotlim(2)],''r'')']);
        % ---- ADDED: epoch label ----
        ep  = eval(['data.trials.t',num2str(i),'.epochs.e',num2str(k)]);
        pos = mod(k-1,4)+1;
        pos_nm = {'pre','RA','LA','post'};
        text(mean(ep), 0.075, sprintf('e%d\n%s',k,pos_nm{pos}), ...
            'HorizontalAlignment','center','VerticalAlignment','top', ...
            'FontSize',7,'Color','k');
    end
    legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','current','amps','Location','eastoutside')
    ylim([-0.01 0.08])
    xlim([0 6.0e5])
    %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
    %use this instead title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
            
end
exportgraphics(fh1, pdfout, "Append", true, "Resolution", 150)




%calculate psd of whole epoch
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
       
        eval(['[data.trials.t',num2str(i),'.psd.e',num2str(j),'.sawRAW,data.trials.t',num2str(i),'.psd.freq]=pwelch(data.trials.t',num2str(i),...
        '.sig.ecog([data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1):data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)],:),512,[],1024,1000);']);
    end
end
data.cfg.trial_data.t1.cond='multi';

for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:eval(['(data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)-data.trials.t',...
                num2str(i),'.epochs.e',num2str(j),'(1))/1000'])
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
                num2str(i),'.sig.ecog([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs.e',num2str(j),...
                '(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1)],:),512,256,512,1000);']);
        end
    end
end

%plot psd curves - separate by epoch - all channels overlaid
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)

        %if j==1
            figure
            hold on
            %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:206),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sawRAW(1:206,:)))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
            legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6')
            title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
            
            
        %end
    end
end
% plot psd curves - separate by channel - all epochs overlaid
spi=[1,3,5,7,9,11];

inverted_chan = 6:-1:1;
for i=1:size(mat_trial_epoch,1)
    fh2 = figure
    set(gcf,'Position',[100 10 560 740])
    for j=1:12
        for k=1:size(data.cfg.info.i_chan,2)
            subplot(6,1,k)
            hold on
            if k==1
                title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
                
            end
            eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:206),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sawRAW(1:206,',num2str(inverted_chan(k)),')))'])
            ylabel(['ch',num2str(inverted_chan(k))])
            if k==6
                xlabel('Hz')
            end
            xlim([0 200])
        end
    end
    %subplot(6,2,1)
    epoch_names_all=eval(['fieldnames(data.trials.t',num2str(i),'.psd);']);
    epoch_names_e=epoch_names_all(strncmp(epoch_names_all,'e',1),:);
    %legend(epoch_names_e)
end
exportgraphics(fh2, pdfout, "Append", true, "Resolution", 150)

%%
figure

spectrogram(data.trials.t1.sig.ecog(:,4),512,[],1024,1000);
            view(90,90);
            colormap jet;
            colorbar('delete');
            colorbar east Visible on;
            axis xy;
            set(gca, 'XDir', 'reverse');
            xlim([0 200]); 

            %%
            [S,F,T] = spectrogram(data.trials.t1.sig.ecog(:,4),512,[],1024,1000);
P = 10*log10(abs(S).^2 + eps);        % [freq x time]

fh3 = figure
subplot(2,1,1)
imagesc(T, F, P);                      % x = time, y = frequency
axis xy
colormap jet; colorbar
ylim([0 200]); xlabel('Time (s)'); ylabel('Frequency (Hz)');
%title('Channel 4 CAR — spectrogram with epochs');
clim([-100 -40])
xlim([0 600])
% ---------- epoch boundaries: vertical lines ----------
hold on
pos_col = [0 0 0; 0 0.8 0; 1 0.6 0; 0.7 0.7 0.7];   % pre, RA, LA, post
pos_nm  = {'pre','RA','LA','post'};
nep = numel(fieldnames(data.trials.t1.epochs));
for k = 1:nep
    e   = data.trials.t1.epochs.(['e' num2str(k)]);
    pos = mod(k-1,4)+1;  c = pos_col(pos,:);
    plot([e(1) e(1)]/1000,[0 200],'-','Color',c,'LineWidth',1.5);
    plot([e(2) e(2)]/1000,[0 200],':','Color',c,'LineWidth',1.2);
    text(e(1)/1000, 202, sprintf('e%d %s',k,pos_nm{pos}), ...
         'Color',c,'FontSize',10,'Rotation',90, ...
         'HorizontalAlignment','left','VerticalAlignment','middle');
end
hold off   
%% WANT THIS IN FIGURE CODE %%
%Common Average Referencing
sumofall = data.trials.t1.sig.ecog(:,1)...
    +data.trials.t1.sig.ecog(:,2)...
    +data.trials.t1.sig.ecog(:,3)...
    +data.trials.t1.sig.ecog(:,4)...
    +data.trials.t1.sig.ecog(:,5)...
    +data.trials.t1.sig.ecog(:,6);

mean_signal = sumofall/6;


ch1 = data.trials.t1.sig.ecog(:,1)-mean_signal;
ch2 = data.trials.t1.sig.ecog(:,2)-mean_signal;
ch3 = data.trials.t1.sig.ecog(:,3)-mean_signal;
ch4 = data.trials.t1.sig.ecog(:,4)-mean_signal;
ch5 = data.trials.t1.sig.ecog(:,5)-mean_signal;
ch6 = data.trials.t1.sig.ecog(:,6)-mean_signal;



data.trials.t1.sig.ecogCAR = [ch1, ch2, ch3, ch4, ch5, ch6];

%%

%plot data (unscaled)
for i=1:size(n_trial,2)
    for j=1:size(data.cfg.info.i_chan,2)
        if j==1
            figure
        end
        eval(['plot(data.trials.t',num2str(i),'.sig.ecogCAR(:,',num2str(j),')*10+j*1e-2)']); hold on
    end
    eval(['plot(data.trials.t',num2str(i),'.sig.sync(:,1))']);
    eval(['plot(data.trials.t',num2str(i),'.sig.trig(:,1))']);
    %eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1))']);
    legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','sync','trig','amps')
    %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
end

% parse epochs
for i=1:size(n_trial,2)
    names_epoch=fieldnames(data.trials);
end

for i=1:size(n_trial,2)
    num_epoch(i)=size(fieldnames(eval(['data.trials.',names_epoch{i},'.epochs'])),1);
end

mat_trial_epoch_sort=sortrows([n_trial;num_epoch]')
mat_trial_epoch=[(1:size(n_trial,2))',mat_trial_epoch_sort(:,1),mat_trial_epoch_sort(:,2)]

% plot data with epochs
for i=1:size(n_trial,2)
    for j=1:size(data.cfg.info.i_chan,2)
        if j==1
            figure
        end
        eval(['plot(data.trials.t',num2str(i),'.sig.ecogCAR(:,',num2str(j),')*10+j*1e-2)']); hold on
    end
    yplotlim=get(gca,'ylim');
    %eval(['plot(data.trials.t',num2str(i),'.sig.sync(:,1))']);
    eval(['plot(data.trials.t',num2str(i),'.sig.trig(:,1))']);
    eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1)/100)']);
    for k=1:mat_trial_epoch(i,3)
        eval(['plot([data.trials.t',num2str(i),'.epochs.e',num2str(k),'(1) data.trials.t',num2str(i),'.epochs.e',num2str(k),'(1)],[yplotlim(1) yplotlim(2)],''g'')']);
        eval(['plot([data.trials.t',num2str(i),'.epochs.e',num2str(k),'(2) data.trials.t',num2str(i),'.epochs.e',num2str(k),'(2)],[yplotlim(1) yplotlim(2)],''r'')']);
    end
    legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','current')
    %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
    %use this instead title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
            
end



%calculate psd of whole epoch
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
       
        eval(['[data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw,data.trials.t',num2str(i),'.psd.freq]=pwelch(data.trials.t',num2str(i),...
        '.sig.ecogCAR([data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1):data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)],:),512,[],1024,1000);']);
    end
end
data.cfg.trial_data.t1.cond='multi';
%plot psd curves - separate by epoch - all channels overlaid
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)

        %if j==1
            figure
            hold on
            %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:206),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw(1:206,:)))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
            legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6')
            title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
            
            
        %end
    end
end

for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:eval(['(data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)-data.trials.t',...
                num2str(i),'.epochs.e',num2str(j),'(1))/1000'])
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
                num2str(i),'.sig.ecogCAR([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs.e',num2str(j),...
                '(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1)],:),512,256,512,1000);']);
        end
    end
end


% calculate mean psd of each freq band for each segment
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(frq_band_ind,2)
            for m=1:eval(['size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals,1)'])
                eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},'(',num2str(m),',:)=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',...
                    num2str(m),',',frq_band_ind{k},',:));']);
                %         ['data_pro00073545_s14.t4.psd.e',num2str(i),'.sai.means.',frq_band_txt{j},'(',num2str(k),',:)=mean(data_pro00073545_s14.t4.psd.e',num2str(i),'.sai.vals(',...
                %             num2str(k),',',frq_band_ind{j},',:))']
                %                 ['data_pro00073545_s14.t4.psd.e',num2str(i),'.sai.means.',frq_band_txt{j},'(k,:)=mean(data_pro00073545_s14.t4.psd.e',num2str(i),'.sai.vals(',...
                %                     'k,',frq_band_ind{j},',:))']
                % ['data_pro00073545_s14.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},'(',num2str(m),',:)=mean(data_pro00073545_s14.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',...
                %                      num2str(m),',',frq_band_ind{k},',:));']
            end        
        end
    end
end


%calculate supermeans and ses
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(frq_band_ind,2)
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.supermeans.',frq_band_txt{k},'=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',...
                frq_band_txt{k},');']);
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.ses.',frq_band_txt{k},'=std(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',...
                frq_band_txt{k},')/sqrt(size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},',1))']);
        end
    end
end


%plotting individual segment means - remember these should not have errorbars
%WARNING - lots of plots, break up into individual freq bands
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=4%:size(frq_band_ind,2)
            for m=1:size(data.cfg.info.i_chan,2)
                if m==1
                    figure;
                    set(gcf,'Position',[100 10 560 740])
                end
                subplot(6,2,spi(m))
                eval(['bar(data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},'(:,m))'])
                ylabel(['ch',num2str(m)])
                if m==1
                    title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',...
                        num2str(i),'.cond']),' ',frq_band_txt{k},' e',num2str(j)])
                end
                if m==size(data.cfg.info.i_chan,2)
                    xlabel('segment #')
                end
            end
        end
    end
end

% plot psd curves - separate by channel - all epochs overlaid
spi=[1,3,5,7,9,11];

for i=1:size(mat_trial_epoch,1)
    figure
    set(gcf,'Position',[100 10 560 740])
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(data.cfg.info.i_chan,2)
            subplot(6,1,k)
            hold on
            if k==1
                title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
                
            end
            eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:206),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw(1:206,',num2str(k),')))'])
            ylabel(['ch',num2str(k)])
            if k==6
                xlabel('Hz')
            end
        end
    end
    %subplot(6,2,1)
    epoch_names_all=eval(['fieldnames(data.trials.t',num2str(i),'.psd);']);
    epoch_names_e=epoch_names_all(strncmp(epoch_names_all,'e',1),:);
    %legend(epoch_names_e)
end
%%

%%
%plot psd curves - separate by epoch - all channels overlaid
for u = 1:6
figure
for i=1:size(mat_trial_epoch,1)
    
    subplot(6,4,1)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(1+((j-1)*4)),'.saw(1:206,', num2str(u), ')))'])
        ylabel('log power')
        xlabel('Hz')
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['pre-movement  '])
        

        %end
    end
    subplot(6,4,2)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(2+((j-1)*4)),'.saw(1:206,', num2str(u),')))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['RA Flexion  '])


        %end
    end
    subplot(6,4,3)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(3+((j-1)*4)),'.saw(1:206,', num2str(u),')))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['LA Flexion  '])


        %end
    end
    subplot(6,4,4)
    for j=1:3

        %if j==1

        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(4+((j-1)*4)),'.saw(1:206,', num2str(u),')))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['Post movement  '])


        %end
    end
    
% 
% band = 'beta';                       % rows 8:16 = 13–30 Hz on the nfft=512 sai path
% ch   = 4;
% cond_labels  = {'Pre-Stim','2.0 mA','Post-Stim'};
% panel_titles = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};
% 
% for k = 1:4
%     subplot(2,4,k+4)
%     epk = [k, k+4, k+8];             % pre-stim, 2.0 mA, post-stim epochs
% 
%     m = zeros(1,3); se = zeros(1,3); ns = zeros(1,3);
%     for c = 1:3
%         v = squeeze(data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(band)(:,ch));
%         v = log10(v(:));             % <-- log the per-second power to match the curves
%         m(c)  = mean(v);
%         se(c) = std(v)/sqrt(numel(v));
%         ns(c) = numel(v);
%     end
% 
%     b = bar(1:3, m); hold on
%     b.BaseValue = -12;
%     errorbar(1:3, m, se, 'k', 'linestyle','none', 'linewidth',1, 'capsize',8);
%     ylim([-12 -10.7])                 % headroom above bars for sig brackets
% 
%     set(gca,'xtick',1:3, 'xticklabel', ...
%         arrayfun(@(c) sprintf('%s\n(n=%d)',cond_labels{c},ns(c)), 1:3, 'uni',0))
%     ylabel('log power'); title(panel_titles{k})
% 
%     % % --- significance brackets from existing KW/multcompare output for this panel ---
%     % kw_mult_output must be this panel's multcompare matrix (m x 6)
%     % sig_pairs = {}; sig_pvals = [];
%     % for line_i = 1:size(kw_mult_output,1)
%     %     line = kw_mult_output(line_i,:);
%     %     if line(6) < 0.05
%     %         sig_pairs{end+1} = [line(1) line(2)];
%     %         sig_pvals(end+1) = line(6);
%     %     end
%     % end
%     % if ~isempty(sig_pvals), sigstar(sig_pairs, sig_pvals); end
% end
% 
end

%
% figure
% 
% spectrogram(data.trials.t1.sig.ecog(:,3),512,[],1024,1000);
% view(90,90);
% colormap jet;
% colorbar('delete');
% colorbar east Visible on;
% axis xy;
% set(gca, 'XDir', 'reverse');
% xlim([0 200]);


% Beta bars from SAI (per-second), LOG space, with SEM error bars + sig brackets

band = 'beta';                       % rows 8:16 = 13–30 Hz on the nfft=512 sai path
ch   = 4;
cond_labels  = {'Pre-Stim','2.0 mA','Post-Stim'};
panel_titles = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};

for i = 1:4
    subplot(6,4,i+16)
    epk = [i, i+4, i+8];             % pre-stim, 2.0 mA, post-stim epochs

    m = zeros(1,3); se = zeros(1,3); ns = zeros(1,3);
    for c = 1:3
        v = squeeze(data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(band)(:,u));
        v = log10(v(:));             % <-- log the per-second power to match the curves
        m(c)  = mean(v);
        se(c) = std(v)/sqrt(numel(v));
        ns(c) = numel(v);
    end

    b = bar(1:3, m); hold on
    b.BaseValue = -12;
    errorbar(1:3, m, se, 'k', 'linestyle','none', 'linewidth',1, 'capsize',8);
    ylim([-12 -10.7])                 % headroom above bars for sig brackets

    set(gca,'xtick',1:3, 'xticklabel', ...
        cond_labels)
    ylabel('log power'); title(panel_titles{i})

    % % --- significance brackets from existing KW/multcompare output for this panel ---
    % kw_mult_output must be this panel's multcompare matrix (m x 6)
    % sig_pairs = {}; sig_pvals = [];
    % for line_i = 1:size(kw_mult_output,1)
    %     line = kw_mult_output(line_i,:);
    %     if line(6) < 0.05
    %         sig_pairs{end+1} = [line(1) line(2)];
    %         sig_pvals(end+1) = line(6);
    %     end
    % end
    % if ~isempty(sig_pvals), sigstar(sig_pairs, sig_pvals); end
end


% Beta bars from SAI (per-second), LOG space, with SEM error bars + sig brackets

band = 'gamma_bb';                       % rows 8:16 = 13–30 Hz on the nfft=512 sai path
ch   = 4;
cond_labels  = {'Pre-Stim','2.0 mA','Post-Stim'};
panel_titles = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};

for i = 1:4
    subplot(6,4,i+20)
    epk = [i, i+4, i+8];             % pre-stim, 2.0 mA, post-stim epochs

    m = zeros(1,3); se = zeros(1,3); ns = zeros(1,3);
    for c = 1:3
        v = squeeze(data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(band)(:,u));
        v = log10(v(:));             % <-- log the per-second power to match the curves
        m(c)  = mean(v);
        se(c) = std(v)/sqrt(numel(v));
        ns(c) = numel(v);
    end

    b = bar(1:3, m); hold on
    b.BaseValue = -14;
    errorbar(1:3, m, se, 'k', 'linestyle','none', 'linewidth',1, 'capsize',8);
    ylim([-14 -12.8])                 % headroom above bars for sig brackets

    set(gca,'xtick',1:3, 'xticklabel', ...
        cond_labels)
    ylabel('log power'); title(panel_titles{i})

    % % --- significance brackets from existing KW/multcompare output for this panel ---
    % kw_mult_output must be this panel's multcompare matrix (m x 6)
    % sig_pairs = {}; sig_pvals = [];
    % for line_i = 1:size(kw_mult_output,1)
    %     line = kw_mult_output(line_i,:);
    %     if line(6) < 0.05
    %         sig_pairs{end+1} = [line(1) line(2)];
    %         sig_pvals(end+1) = line(6);
    %     end
    % end
    % if ~isempty(sig_pvals), sigstar(sig_pairs, sig_pvals); end
end

% Beta bars from SAI (per-second), LOG space, with SEM error bars + sig brackets

band = 'delta';                       % rows 8:16 = 13–30 Hz on the nfft=512 sai path
ch   = 4;
cond_labels  = {'Pre-Stim','2.0 mA','Post-Stim'};
panel_titles = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};

for i = 1:4
    subplot(6,4,i+4)
    epk = [i, i+4, i+8];             % pre-stim, 2.0 mA, post-stim epochs

    m = zeros(1,3); se = zeros(1,3); ns = zeros(1,3);
    for c = 1:3
        v = squeeze(data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(band)(:,u));
        v = log10(v(:));             % <-- log the per-second power to match the curves
        m(c)  = mean(v);
        se(c) = std(v)/sqrt(numel(v));
        ns(c) = numel(v);
    end

    b = bar(1:3, m); hold on
    b.BaseValue = -14;
    errorbar(1:3, m, se, 'k', 'linestyle','none', 'linewidth',1, 'capsize',8);
    ylim([-12 -10.5])                 % headroom above bars for sig brackets

    set(gca,'xtick',1:3, 'xticklabel', ...
        cond_labels)
    ylabel('log power'); title(panel_titles{i})

    % % --- significance brackets from existing KW/multcompare output for this panel ---
    % kw_mult_output must be this panel's multcompare matrix (m x 6)
    % sig_pairs = {}; sig_pvals = [];
    % for line_i = 1:size(kw_mult_output,1)
    %     line = kw_mult_output(line_i,:);
    %     if line(6) < 0.05
    %         sig_pairs{end+1} = [line(1) line(2)];
    %         sig_pvals(end+1) = line(6);
    %     end
    % end
    % if ~isempty(sig_pvals), sigstar(sig_pairs, sig_pvals); end
end

band = 'theta';                       % rows 8:16 = 13–30 Hz on the nfft=512 sai path
ch   = 4;
cond_labels  = {'Pre-Stim','2.0 mA','Post-Stim'};
panel_titles = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};

for i = 1:4
    subplot(6,4,i+8)
    epk = [i, i+4, i+8];             % pre-stim, 2.0 mA, post-stim epochs

    m = zeros(1,3); se = zeros(1,3); ns = zeros(1,3);
    for c = 1:3
        v = squeeze(data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(band)(:,u));
        v = log10(v(:));             % <-- log the per-second power to match the curves
        m(c)  = mean(v);
        se(c) = std(v)/sqrt(numel(v));
        ns(c) = numel(v);
    end

    b = bar(1:3, m); hold on
    b.BaseValue = -14;
    errorbar(1:3, m, se, 'k', 'linestyle','none', 'linewidth',1, 'capsize',8);
    ylim([-12 -10])             % headroom above bars for sig brackets

    set(gca,'xtick',1:3, 'xticklabel', ...
        cond_labels)
    ylabel('log power'); title(panel_titles{i})

    % % --- significance brackets from existing KW/multcompare output for this panel ---
    % kw_mult_output must be this panel's multcompare matrix (m x 6)
    % sig_pairs = {}; sig_pvals = [];
    % for line_i = 1:size(kw_mult_output,1)
    %     line = kw_mult_output(line_i,:);
    %     if line(6) < 0.05
    %         sig_pairs{end+1} = [line(1) line(2)];
    %         sig_pvals(end+1) = line(6);
    %     end
    % end
    % if ~isempty(sig_pvals), sigstar(sig_pairs, sig_pvals); end
end

band = 'alpha';                       % rows 8:16 = 13–30 Hz on the nfft=512 sai path
ch   = 4;
cond_labels  = {'Pre-Stim','2.0 mA','Post-Stim'};
panel_titles = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};

for i = 1:4
    subplot(6,4,i+12)
    epk = [i, i+4, i+8];             % pre-stim, 2.0 mA, post-stim epochs

    m = zeros(1,3); se = zeros(1,3); ns = zeros(1,3);
    for c = 1:3
        v = squeeze(data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(band)(:,u));
        v = log10(v(:));             % <-- log the per-second power to match the curves
        m(c)  = mean(v);
        se(c) = std(v)/sqrt(numel(v));
        ns(c) = numel(v);
    end

    b = bar(1:3, m); hold on
    b.BaseValue = -14;
    errorbar(1:3, m, se, 'k', 'linestyle','none', 'linewidth',1, 'capsize',8);
    ylim([-12 -10])                % headroom above bars for sig brackets

    set(gca,'xtick',1:3, 'xticklabel', ...
        cond_labels)
    ylabel('log power'); title(panel_titles{i})

    % % --- significance brackets from existing KW/multcompare output for this panel ---
    % kw_mult_output must be this panel's multcompare matrix (m x 6)
    % sig_pairs = {}; sig_pvals = [];
    % for line_i = 1:size(kw_mult_output,1)
    %     line = kw_mult_output(line_i,:);
    %     if line(6) < 0.05
    %         sig_pairs{end+1} = [line(1) line(2)];
    %         sig_pvals(end+1) = line(6);
    %     end
    % end
    % if ~isempty(sig_pvals), sigstar(sig_pairs, sig_pvals); end
end
end

%%
function drawSig(pairs, pvals)
% Minimal sigstar replacement. pairs: cell of [x1 x2]; pvals: vector.
yl = ylim; span = yl(2)-yl(1);
base = yl(2) - 0.02*span;              % start just below top
for i = 1:numel(pvals)
    x = pairs{i}; y = base - (i-1)*0.06*span;   % stack brackets downward
    plot([x(1) x(1) x(2) x(2)], [y-0.01*span y y y-0.01*span], 'k', 'linewidth',1);
    if     pvals(i) < 0.001, s = '***';
    elseif pvals(i) < 0.01,  s = '**';
    elseif pvals(i) < 0.05,  s = '*';
    else,                    s = 'ns'; end
    text(mean(x), y+0.005*span, s, 'HorizontalAlignment','center', 'FontSize',10);
end
end
%% 4 KW tests: within each movement phase, test across the 3 stim states
ch = 4; bands = {'delta', 'theta', 'alpha', 'beta', 'gamma', 'gamma_l', 'gamma_bb'};
% movement phase -> its 3 epochs [pre-stim, 2.0mA, post-stim]
phase_epochs = {[1 5 9], [2 6 10], [3 7 11], [4 8 12]};
phase_names  = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};
stim_names   = ["preStim","2.0mA","postStim"];
results_stim_in_move = table();   % ADDED: collect stats
for ch = 1:6
for band=1:5
figure
for ph = 1:4
    eps = phase_epochs{ph};
    vals = []; grp = strings(1,0); mn = zeros(1,3); se = zeros(1,3);
    for c = 1:3
        v = data.trials.t1.psd.(['e' num2str(eps(c))]).sai.means.(bands{band})(:, ch);
        v = log10(v(:)');                         % <-- delete log10 if field already log
        vals = [vals, v];
        grp  = [grp, repmat(stim_names(c), 1, numel(v))];
        mn(c) = mean(v); se(c) = std(v)/sqrt(numel(v));
    end
    [p, ~, st] = kruskalwallis(vals, grp, 'off');
    mc = multcompare(st, 'ctype','bonferroni', 'display','off');

    % ADDED: store one row per pairwise comparison
    for r = 1:size(mc,1)
        results_stim_in_move = [results_stim_in_move; table( ...
            string(bands{band}), ch, string(phase_names{ph}), p, ...
            stim_names(mc(r,1)), stim_names(mc(r,2)), mc(r,4), mc(r,6), ...
            'VariableNames', {'Band','Channel','MovementPhase','KW_omnibus_p', ...
                              'Group1','Group2','Estimate','Pairwise_p'})];
    end

    subplot(1,4,ph); hold on
    b = bar(1:3, mn); b.BaseValue = min(mn)-0.5;
    errorbar(1:3, mn, se, '.k');
    ylim([min(mn)-0.5, max(mn)+0.5]);
    sig = mc(mc(:,6)<0.05, :);
    drawSig(arrayfun(@(k){[sig(k,1) sig(k,2)]}, 1:size(sig,1)), sig(sig(:,6)<0.05,6));
    set(gca,'xtick',1:3,'xticklabel',stim_names);
    title(sprintf('%s (KW p=%.3g)', phase_names{ph}, p));
    ylabel(['ch' num2str(ch)]); hold off
end
sgtitle('Stim effect within each movement phase');
end
end
writetable(results_stim_in_move, 'stats_stim_within_movement.csv');   % ADDED

%% 3 KW tests: within each stim state, test across the 4 movement phases
ch = 4; bands = {'delta', 'theta', 'alpha', 'beta', 'gamma'};
% stim state -> its 4 epochs [pre-move, RA, LA, post-move]
stim_epochs = {[1 2 3 4], [5 6 7 8], [9 10 11 12]};
stim_names2 = {'Pre-Stim','2.0 mA','Post-Stim'};
move_names  = ["pre","RA","LA","post"];
results_move_in_stim = table();   % ADDED: collect stats
for ch=1:6
for band=1:5
figure
for st = 1:3
    eps = stim_epochs{st};
    vals = []; grp = strings(1,0); mn = zeros(1,4); se = zeros(1,4);
    for c = 1:4
        v = data.trials.t1.psd.(['e' num2str(eps(c))]).sai.means.(bands{band})(:, ch);
        v = log10(v(:)');                         % <-- delete log10 if field already log
        vals = [vals, v];
        grp  = [grp, repmat(move_names(c), 1, numel(v))];
        mn(c) = mean(v); se(c) = std(v)/sqrt(numel(v));
    end
    [p, ~, stt] = kruskalwallis(vals, grp, 'off');
    mc = multcompare(stt, 'ctype','bonferroni', 'display','off');

    % ADDED: store one row per pairwise comparison
    for r = 1:size(mc,1)
        results_move_in_stim = [results_move_in_stim; table( ...
            string(bands{band}), ch, string(stim_names2{st}), p, ...
            move_names(mc(r,1)), move_names(mc(r,2)), mc(r,4), mc(r,6), ...
            'VariableNames', {'Band','Channel','StimState','KW_omnibus_p', ...
                              'Group1','Group2','Estimate','Pairwise_p'})];
    end

    subplot(1,3,st); hold on
    b = bar(1:4, mn); b.BaseValue = min(mn)-0.5;
    errorbar(1:4, mn, se, '.k');
    ylim([min(mn)-0.5, max(mn)+0.5]);
    sig = mc(mc(:,6)<0.05, :);
    drawSig(arrayfun(@(k){[sig(k,1) sig(k,2)]}, 1:size(sig,1)), sig(sig(:,6)<0.05,6));
    set(gca,'xtick',1:4,'xticklabel',move_names);
    title(sprintf('%s (KW p=%.3g)', stim_names2{st}, p));
    ylabel(['ch' num2str(ch)]); hold off
end
sgtitle('Movement effect within each stim state');
end
end
writetable(results_move_in_stim, 'stats_movement_within_stim.csv');   % ADDED

%% TWO-WAY ANOVA: movement phase x stim state (with interaction), per-second beta

ch = 4; bands = {'delta', 'theta', 'alpha', 'beta', 'gamma'};

move_of = ["pre","RA","LA","post"];          % movement index 1..4
stim_of = ["preStim","2.0mA","postStim"]; % stim index 1..3
results_twoway = table();   % ADDED: collect stats
for band=1:5
for ch = 1:6
y = []; g_move = strings(1,0); g_stim = strings(1,0);
for e = 1:12
    v = data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{band})(:, ch);
    v = log10(v(:)');                         % <-- DELETE log10 if field already log
    mi = mod(e-1,4) + 1;                       % movement phase: e1/e5/e9->1, e2/e6/e10->2, ...
    si = floor((e-1)/4) + 1;                   % stim state:     e1..e4->1, e5..e8->2, e9..e12->3
    y      = [y, v];
    g_move = [g_move, repmat(move_of(mi), 1, numel(v))];
    g_stim = [g_stim, repmat(stim_of(si), 1, numel(v))];
end

[p, tbl, stats, terms] = anovan(y, {g_move, g_stim}, ...
    'model','interaction', ...
    'varnames', {'movement','stim'}, ...
    'display','on');          % 'on' prints the ANOVA table figure; 'off' to suppress

% p(1)=movement main effect, p(2)=stim main effect, p(3)=movement x stim interaction
fprintf('\nmovement main effect  p = %.4g\n', p(1));
fprintf('stim main effect      p = %.4g\n', p(2));
fprintf('interaction           p = %.4g\n', p(3));

% --- post-hoc where a factor (or the interaction) is significant ---
% stim across all data:
mc_stim = multcompare(stats, 'Dimension', 2, 'ctype','bonferroni','display','off');
% movement across all data:
mc_move = multcompare(stats, 'Dimension', 1, 'ctype','bonferroni','display','off');
% cell-by-cell (interaction) post-hoc:
mc_int  = multcompare(stats, 'Dimension', [1 2], 'ctype','bonferroni','display','off');

% ADDED: store one row per band x channel with the three term p-values
results_twoway = [results_twoway; table( ...
    string(bands{band}), ch, p(1), p(2), p(3), ...
    'VariableNames', {'Band','Channel','p_movement','p_stim','p_interaction'})];
end
end
writetable(results_twoway, 'stats_twoway_anova.csv');   % ADDED

%%
%% TWO-WAY ANOVA (n=12): one mean per epoch, main effects only (no interaction possible)
ch = 4; bands = {'delta', 'theta', 'alpha', 'beta', 'gamma'};
move_of = ["pre","RA","LA","post"];
stim_of = ["preStim","2.0mA","postStim"];
results_twoway_n12 = table();   % collect stats

for band = 1:5
    for ch = 1:6
        y = zeros(1,12); g_move = strings(1,12); g_stim = strings(1,12);
        for e = 1:12
            v = data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{band})(:, ch);
            v = log10(v(:));                 % <-- DELETE log10 if field already log
            y(e)      = mean(v);             % ONE value per epoch = the epoch mean
            mi = mod(e-1,4) + 1;
            si = floor((e-1)/4) + 1;
            g_move(e) = move_of(mi);
            g_stim(e) = stim_of(si);
        end

        % additive model only ('linear') — interaction is NOT estimable at n=12
        [p, tbl, stats] = anovan(y, {g_move, g_stim}, ...
            'model','linear', ...
            'varnames',{'movement','stim'}, ...
            'display','off');

        % p(1)=movement main effect, p(2)=stim main effect
        results_twoway_n12 = [results_twoway_n12; table( ...
            string(bands{band}), ch, p(1), p(2), ...
            'VariableNames', {'Band','Channel','p_movement','p_stim'})];
    end
end
writetable(results_twoway_n12, 'stats_twoway_n12.csv');

%% 12 FIGURES: 2 per channel — movement-state and stim-state, with KW stars
bands        = {'delta','theta','alpha','beta','gamma_l', 'gamma_bb','gamma'};
band_titles  = {'Delta','Theta','Alpha','Beta','Low Gamma', 'High Gamma','Broadband Gamma'};

phase_epochs = {[1 5 9], [2 6 10], [3 7 11], [4 8 12]};      % movement phase -> 3 stim epochs
phase_names  = {'Pre-move','RA Flex','LA Flex','Post-move'};
stim_epochs  = {[1 2 3 4], [5 6 7 8], [9 10 11 12]};         % stim state -> 4 movement epochs
stim_names   = {'Pre-Stim','Intra 2.0mA','Post-Stim'};
move_labels  = {'pre','R','L','post'};
stim_labels  = {'pre','intra','post'};
pdfout = 's26_psd_panels_4.pdf';
% ============ FIGURE 2 per channel: STIM state (3 bars), columns = movement phase ============
for ch = 4
    fh8 = figure('Name',sprintf('ch%d  stim state',ch));
    set(gcf,'Position',[60 30 1150 1050])
    for bi = 1:7 %change band
        for ph = 1:4
            subplot(7,4,(bi-1)*4 + ph); hold on
            epk = phase_epochs{ph};
            vals = []; grp = strings(1,0); mn = zeros(1,3); sem = zeros(1,3);
            for c = 1:3
                v = data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(bands{bi})(:, ch);
                v = log10(v(:))';
                vals = [vals, v];
                grp  = [grp, repmat(string(stim_labels{c}),1,numel(v))];
                mn(c) = mean(v); sem(c) = std(v)/sqrt(numel(v));
            end
            [p_kw,~,kwst] = kruskalwallis(vals, grp, 'off');
            mc = multcompare(kwst,'ctype','bonferroni','display','off');

            lo = min(mn-sem); hi = max(mn+sem); rg = hi-lo; if rg==0, rg=0.1; end
            b = bar(1:3, mn); b.BaseValue = lo - 0.20*rg;
            errorbar(1:3, mn, sem, 'k','linestyle','none','linewidth',1);
            ylim([lo-0.20*rg, hi+0.50*rg]);
            set(gca,'xtick',1:3,'xticklabel',stim_labels);

            sig = mc(mc(:,6)<0.05,:);
            if ~isempty(sig)
                drawSig(arrayfun(@(k){[sig(k,1) sig(k,2)]},1:size(sig,1)), sig(:,6));
            end

            if bi==1, title(sprintf('%s\np=%.3g',phase_names{ph},p_kw),'fontsize',9);
            else,     title(sprintf('p=%.3g',p_kw),'fontsize',8); end
            if ph==1, ylabel(sprintf('%s\nlog power',band_titles{bi}),'fontsize',9); end
            hold off
        end
    end
    sgtitle(sprintf('Channel %d — stimulation effect within each movement phase',ch));
    exportgraphics(fh8, pdfout, "Append", true,"Resolution",150)
end


% ============ FIGURE 1 per channel: MOVEMENT state (4 bars), columns = stim state ============
for ch = 4
    fh7 = figure('Name',sprintf('ch%d  movement state',ch));
    set(gcf,'Position',[60 30 1000 1050])
    for bi = 1:7 %change band
        for st = 1:3
            subplot(7,3,(bi-1)*3 + st); hold on
            epk = stim_epochs{st};
            vals = []; grp = strings(1,0); mn = zeros(1,4); sem = zeros(1,4);
            for c = 1:4
                v = data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(bands{bi})(:, ch);
                v = log10(v(:))';
                vals = [vals, v];
                grp  = [grp, repmat(string(move_labels{c}),1,numel(v))];
                mn(c) = mean(v); sem(c) = std(v)/sqrt(numel(v));
            end
            [p_kw,~,kwst] = kruskalwallis(vals, grp, 'off');
            mc = multcompare(kwst,'ctype','bonferroni','display','off');

            lo = min(mn-sem); hi = max(mn+sem); rg = hi-lo; if rg==0, rg=0.1; end
            b = bar(1:4, mn); b.BaseValue = lo - 0.20*rg;
            errorbar(1:4, mn, sem, 'k','linestyle','none','linewidth',1);
            ylim([lo-0.20*rg, hi+0.50*rg]);
            set(gca,'xtick',1:4,'xticklabel',move_labels);

            sig = mc(mc(:,6)<0.05,:);
            if ~isempty(sig)
                drawSig(arrayfun(@(k){[sig(k,1) sig(k,2)]},1:size(sig,1)), sig(:,6));
            end

            if bi==1, title(sprintf('%s\np=%.3g',stim_names{st},p_kw),'fontsize',9);
            else,     title(sprintf('p=%.3g',p_kw),'fontsize',8); end
            if st==1, ylabel(sprintf('%s\nlog power',band_titles{bi}),'fontsize',9); end
            hold off
        end
    end
    sgtitle(sprintf('Channel %d — movement effect within each stimulation state',ch));
    exportgraphics(fh7, pdfout, "Append", true,"Resolution",150)
end


% %% n=12 TWO-WAY ANOVA PLOTS — 1 figure per channel (5 bands x 3 panels)
% bands       = {'delta','theta','alpha','beta','gamma'};
% band_titles = {'Delta','Theta','Alpha','Beta','Gamma'};
% move_of  = ["pre","RA","LA","post"];   stim_of  = ["preStim","2.0mA","postStim"];
% move_lab = {'pre','R','L','post'};     stim_lab = {'pre','intra','post'};
% cols = lines(3);
% 
% for ch = 1:6
%     figure('Name',sprintf('ch%d  n=12 two-way',ch));
%     set(gcf,'Position',[60 30 1100 1050])
%     for bi = 1:5
%         % ---- 12 epoch means -> grid(stim, movement) ----
%         y = zeros(1,12); gm = strings(1,12); gs = strings(1,12); G = zeros(3,4);
%         for e = 1:12
%             v  = data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:, ch);
%             mu = mean(log10(v(:)));
%             mi = mod(e-1,4)+1;  si = floor((e-1)/4)+1;
%             y(e)=mu; gm(e)=move_of(mi); gs(e)=stim_of(si); G(si,mi)=mu;
%         end
%         p = anovan(y,{gm,gs},'model','linear', ...
%             'varnames',{'movement','stim'},'display','off');
% 
%         % ---- col 1: interaction plot (all 12 points) ----
%         subplot(5,3,(bi-1)*3+1); hold on
%         for si = 1:3
%             plot(1:4, G(si,:), '-o','Color',cols(si,:), ...
%                 'MarkerFaceColor',cols(si,:),'linewidth',1.2,'markersize',5);
%         end
%         xlim([0.5 4.5]); set(gca,'xtick',1:4,'xticklabel',move_lab);
%         ylabel(sprintf('%s\nlog power',band_titles{bi}),'fontsize',9);
%         if bi==1, title('all 12 cells','fontsize',9); legend(stim_lab,'fontsize',7,'location','best'); end
%         hold off
% 
%         % ---- col 2: movement marginals (each averages 3 stim states) ----
%         mM = mean(G,1);  sM = std(G,0,1)/sqrt(3);
%         subplot(5,3,(bi-1)*3+2); hold on
%         lo=min(mM-sM); hi=max(mM+sM); rg=hi-lo; if rg==0, rg=0.1; end
%         b=bar(1:4,mM); b.BaseValue = lo-0.20*rg;
%         errorbar(1:4,mM,sM,'k','linestyle','none','linewidth',1);
%         ylim([lo-0.20*rg hi+0.30*rg]);
%         set(gca,'xtick',1:4,'xticklabel',move_lab);
%         title(sprintf('movement  p=%.3g',p(1)),'fontsize',9);
%         hold off
% 
%         % ---- col 3: stim marginals (each averages 4 movement phases) ----
%         mS = mean(G,2)';  sS = (std(G,0,2)/sqrt(4))';
%         subplot(5,3,(bi-1)*3+3); hold on
%         lo=min(mS-sS); hi=max(mS+sS); rg=hi-lo; if rg==0, rg=0.1; end
%         b=bar(1:3,mS); b.BaseValue = lo-0.20*rg;
%         errorbar(1:3,mS,sS,'k','linestyle','none','linewidth',1);
%         ylim([lo-0.20*rg hi+0.30*rg]);
%         set(gca,'xtick',1:3,'xticklabel',stim_lab);
%         title(sprintf('stim  p=%.3g',p(2)),'fontsize',9);
%         hold off
%     end
%     sgtitle(sprintf('Channel %d — n=12 two-way ANOVA (epoch means, additive model)',ch));
% end




%% CAR vs Non-CAR


for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:eval(['(data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)-data.trials.t',...
                num2str(i),'.epochs.e',num2str(j),'(1))/1000'])
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
                num2str(i),'.sig.ecog([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs.e',num2str(j),...
                '(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1)],:),512,256,512,1000);']);
        end
    end
end


% calculate mean psd of each freq band for each segment
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(frq_band_ind,2)
            for m=1:eval(['size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.vals,1)'])
                eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.means.',frq_band_txt{k},'(',num2str(m),',:)=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.vals(',...
                    num2str(m),',',frq_band_ind{k},',:));']);
                %         ['data_pro00073545_s14.t4.psd.e',num2str(i),'.saiRAW.means.',frq_band_txt{j},'(',num2str(k),',:)=mean(data_pro00073545_s14.t4.psd.e',num2str(i),'.saiRAW.vals(',...
                %             num2str(k),',',frq_band_ind{j},',:))']
                %                 ['data_pro00073545_s14.t4.psd.e',num2str(i),'.saiRAW.means.',frq_band_txt{j},'(k,:)=mean(data_pro00073545_s14.t4.psd.e',num2str(i),'.saiRAW.vals(',...
                %                     'k,',frq_band_ind{j},',:))']
                % ['data_pro00073545_s14.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.means.',frq_band_txt{k},'(',num2str(m),',:)=mean(data_pro00073545_s14.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.vals(',...
                %                      num2str(m),',',frq_band_ind{k},',:));']
            end        
        end
    end
end


%calculate supermeans and ses
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(frq_band_ind,2)
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.supermeans.',frq_band_txt{k},'=mean(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.means.',...
                frq_band_txt{k},');']);
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.ses.',frq_band_txt{k},'=std(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.means.',...
                frq_band_txt{k},')/sqrt(size(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.means.',frq_band_txt{k},',1))']);
        end
    end
end


%plotting individual segment means - remember these should not have errorbars
%WARNING - lots of plots, break up into individual freq bands
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=4%:size(frq_band_ind,2)
            for m=1:size(data.cfg.info.i_chan,2)
                if m==1
                    figure;
                    set(gcf,'Position',[100 10 560 740])
                end
                subplot(6,2,spi(m))
                eval(['bar(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saiRAW.means.',frq_band_txt{k},'(:,m))'])
                ylabel(['ch',num2str(m)])
                if m==1
                    title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',...
                        num2str(i),'.cond']),' ',frq_band_txt{k},' e',num2str(j)])
                end
                if m==size(data.cfg.info.i_chan,2)
                    xlabel('segment #')
                end
            end
        end
    end
end

% plot psd curves - separate by channel - all epochs overlaid
spi=[1,3,5,7,9,11];

for i=1:size(mat_trial_epoch,1)
    figure
    set(gcf,'Position',[100 10 560 740])
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(data.cfg.info.i_chan,2)
            subplot(6,1,k)
            hold on
            if k==1
                title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])

            end
            eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:206),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw(1:206,',num2str(k),')))'])
            ylabel(['ch',num2str(k)])
            if k==6
                xlabel('Hz')
            end
        end
    end
    %subplot(6,2,1)
    epoch_names_all=eval(['fieldnames(data.trials.t',num2str(i),'.psd);']);
    epoch_names_e=epoch_names_all(strncmp(epoch_names_all,'e',1),:);
    %legend(epoch_names_e)
end
%%

% 12 FIGURES: 2 per channel — movement-state and stim-state, with KW stars
bands        = {'delta','theta','alpha','beta','gamma'};
band_titles  = {'Delta','Theta','Alpha','Beta','Gamma'};

phase_epochs = {[1 5 9], [2 6 10], [3 7 11], [4 8 12]};      % movement phase -> 3 stim epochs
phase_names  = {'Pre-move','RA Flex','LA Flex','Post-move'};
stim_epochs  = {[1 2 3 4], [5 6 7 8], [9 10 11 12]};         % stim state -> 4 movement epochs
stim_names   = {'Pre-Stim','Intra 2.0mA','Post-Stim'};
move_labels  = {'pre','R','L','post'};
stim_labels  = {'pre','intra','post'};

% ============ FIGURE 1 per channel: MOVEMENT state (4 bars), columns = stim state ============
for ch = 1:6
    figure('Name',sprintf('ch%d  movement state',ch));
    set(gcf,'Position',[60 30 1000 1050])
    for bi = 1:5
        for st = 1:3
            subplot(5,3,(bi-1)*3 + st); hold on
            epk = stim_epochs{st};
            vals = []; grp = strings(1,0); mn = zeros(1,4); sem = zeros(1,4);
            for c = 1:4
                v = data.trials.t1.psd.(['e' num2str(epk(c))]).saiRAW.means.(bands{bi})(:, ch);
                v = log10(v(:))';
                vals = [vals, v];
                grp  = [grp, repmat(string(move_labels{c}),1,numel(v))];
                mn(c) = mean(v); sem(c) = std(v)/sqrt(numel(v));
            end
            [p_kw,~,kwst] = kruskalwallis(vals, grp, 'off');
            mc = multcompare(kwst,'ctype','bonferroni','display','off');

            lo = min(mn-sem); hi = max(mn+sem); rg = hi-lo; if rg==0, rg=0.1; end
            b = bar(1:4, mn); b.BaseValue = lo - 0.20*rg;
            errorbar(1:4, mn, sem, 'k','linestyle','none','linewidth',1);
            ylim([lo-0.20*rg, hi+0.50*rg]);
            set(gca,'xtick',1:4,'xticklabel',move_labels);

            sig = mc(mc(:,6)<0.05,:);
            if ~isempty(sig)
                drawSig(arrayfun(@(k){[sig(k,1) sig(k,2)]},1:size(sig,1)), sig(:,6));
            end

            if bi==1, title(sprintf('%s\np=%.3g',stim_names{st},p_kw),'fontsize',9);
            else,     title(sprintf('p=%.3g',p_kw),'fontsize',8); end
            if st==1, ylabel(sprintf('%s\nlog power',band_titles{bi}),'fontsize',9); end
            hold off
        end
    end
    sgtitle(sprintf('Channel %d — movement effect within each stimulation state NO CAR',ch));
end

% ============ FIGURE 2 per channel: STIM state (3 bars), columns = movement phase ============
for ch = 1:6
    figure('Name',sprintf('ch%d  stim state',ch));
    set(gcf,'Position',[60 30 1150 1050])
    for bi = 1:5
        for ph = 1:4
            subplot(5,4,(bi-1)*4 + ph); hold on
            epk = phase_epochs{ph};
            vals = []; grp = strings(1,0); mn = zeros(1,3); sem = zeros(1,3);
            for c = 1:3
                v = data.trials.t1.psd.(['e' num2str(epk(c))]).saiRAW.means.(bands{bi})(:, ch);
                v = log10(v(:))';
                vals = [vals, v];
                grp  = [grp, repmat(string(stim_labels{c}),1,numel(v))];
                mn(c) = mean(v); sem(c) = std(v)/sqrt(numel(v));
            end
            [p_kw,~,kwst] = kruskalwallis(vals, grp, 'off');
            mc = multcompare(kwst,'ctype','bonferroni','display','off');

            lo = min(mn-sem); hi = max(mn+sem); rg = hi-lo; if rg==0, rg=0.1; end
            b = bar(1:3, mn); b.BaseValue = lo - 0.20*rg;
            errorbar(1:3, mn, sem, 'k','linestyle','none','linewidth',1);
            ylim([lo-0.20*rg, hi+0.50*rg]);
            set(gca,'xtick',1:3,'xticklabel',stim_labels);

            sig = mc(mc(:,6)<0.05,:);
            if ~isempty(sig)
                drawSig(arrayfun(@(k){[sig(k,1) sig(k,2)]},1:size(sig,1)), sig(:,6));
            end

            if bi==1, title(sprintf('%s\np=%.3g',phase_names{ph},p_kw),'fontsize',9);
            else,     title(sprintf('p=%.3g',p_kw),'fontsize',8); end
            if ph==1, ylabel(sprintf('%s\nlog power',band_titles{bi}),'fontsize',9); end
            hold off
        end
    end
    sgtitle(sprintf('Channel %d — stimulation effect within each movement phase NO CAR',ch));
end

%%
save('data_pro00073545_s026', 'data')
%%
%plot psd curves - separate by epoch - all channels overlaid
for u = 1:6
figure
for i=1:size(mat_trial_epoch,1)
    
    subplot(6,4,1)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(1+((j-1)*4)),'.sawRAW(1:206,', num2str(u), ')))'])
        ylabel('log power')
        xlabel('Hz')
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['pre-movement  '])
        

        %end
    end
    subplot(6,4,2)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(2+((j-1)*4)),'.sawRAW(1:206,', num2str(u),')))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['RA Flexion  '])


        %end
    end
    subplot(6,4,3)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(3+((j-1)*4)),'.sawRAW(1:206,', num2str(u),')))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['LA Flexion  '])


        %end
    end
    subplot(6,4,4)
    for j=1:3

        %if j==1

        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(4+((j-1)*4)),'.sawRAW(1:206,', num2str(u),')))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['Post movement  '])


        %end
    end
    
% 
% band = 'beta';                       % rows 8:16 = 13–30 Hz on the nfft=512 sai path
% ch   = 4;
% cond_labels  = {'Pre-Stim','2.0 mA','Post-Stim'};
% panel_titles = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};
% 
% for k = 1:4
%     subplot(2,4,k+4)
%     epk = [k, k+4, k+8];             % pre-stim, 2.0 mA, post-stim epochs
% 
%     m = zeros(1,3); se = zeros(1,3); ns = zeros(1,3);
%     for c = 1:3
%         v = squeeze(data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(band)(:,ch));
%         v = log10(v(:));             % <-- log the per-second power to match the curves
%         m(c)  = mean(v);
%         se(c) = std(v)/sqrt(numel(v));
%         ns(c) = numel(v);
%     end
% 
%     b = bar(1:3, m); hold on
%     b.BaseValue = -12;
%     errorbar(1:3, m, se, 'k', 'linestyle','none', 'linewidth',1, 'capsize',8);
%     ylim([-12 -10.7])                 % headroom above bars for sig brackets
% 
%     set(gca,'xtick',1:3, 'xticklabel', ...
%         arrayfun(@(c) sprintf('%s\n(n=%d)',cond_labels{c},ns(c)), 1:3, 'uni',0))
%     ylabel('log power'); title(panel_titles{k})
% 
%     % % --- significance brackets from existing KW/multcompare output for this panel ---
%     % kw_mult_output must be this panel's multcompare matrix (m x 6)
%     % sig_pairs = {}; sig_pvals = [];
%     % for line_i = 1:size(kw_mult_output,1)
%     %     line = kw_mult_output(line_i,:);
%     %     if line(6) < 0.05
%     %         sig_pairs{end+1} = [line(1) line(2)];
%     %         sig_pvals(end+1) = line(6);
%     %     end
%     % end
%     % if ~isempty(sig_pvals), sigstar(sig_pairs, sig_pvals); end
% end
% 
end
end
%
% figure
% 
% spectrogram(data.trials.t1.sig.ecog(:,3),512,[],1024,1000);
% view(90,90);
% colormap jet;
% colorbar('delete');
% colorbar east Visible on;
% axis xy;
% set(gca, 'XDir', 'reverse');
% xlim([0 200]);


%%
%%
%plot psd curves - separate by epoch - all channels overlaid
for u = 1:6
figure
for i=1:size(mat_trial_epoch,1)
    
    subplot(1,4,1)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(1+((j-1)*4)),'.saw(1:206,', num2str(u), ')))'])
        ylabel('log power')
        xlabel('Hz')
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['pre-movement  '])
        

        %end
    end
    subplot(1,4,2)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(2+((j-1)*4)),'.saw(1:206,', num2str(u),')))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['RA Flexion  '])


        %end
    end

    figure
    subplot(2,2,1)
    for j=1:3

        %if j==1
        
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(3+((j-1)*4)),'.saw(1:206,', num2str(u),')), "Linewidth", 2)'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['LA Flexion  '])
        xlim([0 200])

        %end
    end
    subplot(2,2,2)
    for j=1:3

        %if j==1

        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t1.psd.freq(1:206),log10(data.trials.t1.psd.e',num2str(4+((j-1)*4)),'.saw(1:206,', num2str(u),')), "Linewidth", 2)'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Pre-Stim','2.0 mA','Post-Stim')
        title(['Post movement  '])
        xlim([0 200])
    
        %end
    end
    
% 
% band = 'beta';                       % rows 8:16 = 13–30 Hz on the nfft=512 sai path
% ch   = 4;
% cond_labels  = {'Pre-Stim','2.0 mA','Post-Stim'};
% panel_titles = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};
% 
% for k = 1:4
%     subplot(2,4,k+4)
%     epk = [k, k+4, k+8];             % pre-stim, 2.0 mA, post-stim epochs
% 
%     m = zeros(1,3); se = zeros(1,3); ns = zeros(1,3);
%     for c = 1:3
%         v = squeeze(data.trials.t1.psd.(['e' num2str(epk(c))]).sai.means.(band)(:,ch));
%         v = log10(v(:));             % <-- log the per-second power to match the curves
%         m(c)  = mean(v);
%         se(c) = std(v)/sqrt(numel(v));
%         ns(c) = numel(v);
%     end
% 
%     b = bar(1:3, m); hold on
%     b.BaseValue = -12;
%     errorbar(1:3, m, se, 'k', 'linestyle','none', 'linewidth',1, 'capsize',8);
%     ylim([-12 -10.7])                 % headroom above bars for sig brackets
% 
%     set(gca,'xtick',1:3, 'xticklabel', ...
%         arrayfun(@(c) sprintf('%s\n(n=%d)',cond_labels{c},ns(c)), 1:3, 'uni',0))
%     ylabel('log power'); title(panel_titles{k})
% 
%     % % --- significance brackets from existing KW/multcompare output for this panel ---
%     % kw_mult_output must be this panel's multcompare matrix (m x 6)
%     % sig_pairs = {}; sig_pvals = [];
%     % for line_i = 1:size(kw_mult_output,1)
%     %     line = kw_mult_output(line_i,:);
%     %     if line(6) < 0.05
%     %         sig_pairs{end+1} = [line(1) line(2)];
%     %         sig_pvals(end+1) = line(6);
%     %     end
%     % end
%     % if ~isempty(sig_pvals), sigstar(sig_pairs, sig_pvals); end
% end
% 
end
end
%
% figure
% 
% spectrogram(data.trials.t1.sig.ecog(:,3),512,[],1024,1000);
% view(90,90);
% colormap jet;
% colorbar('delete');
% colorbar east Visible on;
% axis xy;
% set(gca, 'XDir', 'reverse');
% xlim([0 200]);

%%
band = 'beta';
nch  = 6;
mv_titles   = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};
cond_labels = {'Pre-Stim','2.0 mA','Post-Stim'};
p = data.trials.t1.psd;

figure
for k = 1:4
    subplot(2,2,k); hold on
    m = zeros(nch,3); se = zeros(nch,3);

    for c = 1:3
        e = p.(sprintf('e%d', k + (c-1)*4));
        for ch = 1:nch
            v = log10(e.sai.means.(band)(:,ch));   % per-second power, logged
            m(ch,c)  = mean(v);
            se(ch,c) = std(v)/sqrt(numel(v));
        end
    end

    for c = 1:3
        errorbar(1:nch, m(:,c), se(:,c), '-o', 'LineWidth', 2, 'CapSize', 6);
    end

    xlim([0.5 nch+0.5]); xticks(1:nch)
    xlabel('Channel'); ylabel('log power')
    title(mv_titles{k})
    if k == 1, legend(cond_labels, 'Location','best'); end
end
sgtitle(sprintf('%s power by channel', band))

%% 24-panel: channels (rows) x movement state (cols), 3 stim curves per panel
pdfout = 's26_psd_panels_2.pdf';
if exist(pdfout,'file'), delete(pdfout); end

NF       = 206;                                   % freq points to plot
move_lab = {'Pre-movement','RA Flexion','LA Flexion','Post-movement'};
cond_lab = {'Pre-Stim','2.0 mA','Post-Stim'};

fh1 = figure('Name','PSD by movement state');
set(gcf,'Position',[30 30 1500 1100])
u=4;                                      % channel -> row
    for pos = 1:4                                  % movement state -> col
        subplot(4,4,pos); hold on
        for j = 1:3                                % stim condition -> curve
            e = (j-1)*4 + pos;
            plot(data.trials.t1.psd.freq(1:NF), ...
                log10(data.trials.t1.psd.(['e' num2str(e)]).saw(1:NF,u)), ...
                'linewidth',2);
        end
        if u==4,   title(move_lab{pos},'fontsize',10); end
        if pos==1, ylabel(sprintf('ch%d\nlog power',u),'fontsize',9); end
        if u==6,   xlabel('Hz'); end
        if pos==4, legend(cond_lab,'fontsize',7,'location','northeast'); end
        grid on; hold off
        xlim([0 200])
        ylim([-16 -10])
        
    end

sgtitle('PSD by movement state - Channel 4','fontsize',13);
exportgraphics(fh1, pdfout, 'Resolution',150);

%18-panel: channels (rows) x stim state (cols), 4 movement curves per panel
NF       = 206;
move_lab = {'pre-move','RA flex','LA flex','post-move'};
cond_lab = {'Pre-Stim','2.0 mA','Post-Stim'};

fh2 = figure('Name','PSD by stimulation state');
set(gcf,'Position',[30 30 1200 1100])                                      % channel -> row
    for j = 1:3                                    % stim state -> col
        subplot(4,3,j); hold on
        for pos = 1:4                              % movement state -> curve
            e = (j-1)*4 + pos;
            plot(data.trials.t1.psd.freq(1:NF), ...
                log10(data.trials.t1.psd.(['e' num2str(e)]).saw(1:NF,u)), ...
                'linewidth',2);
        end
        if u==4, title(cond_lab{j},'fontsize',10); end
        if j==1, ylabel(sprintf('ch%d\nlog power',u),'fontsize',9); end
        if u==6, xlabel('Hz'); end
        if j==3, legend(move_lab,'fontsize',7,'location','northeast'); end
        grid on; hold off
        xlim([0 200])
        ylim([-16 -10])
    end

sgtitle('PSD by stimulation state — Channel 4','fontsize',13);
exportgraphics(fh2, pdfout, 'Append', true, 'Resolution',150);

%% Subject 26 — stats only, no figures
chan_list = 1:6;
bands     = {'delta','theta','alpha','beta','gamma'};
move_lab  = {'pre','RA','LA','post'};
cond_lab  = {'Pre-Stim','Intra','Post-Stim'};
epoch_of  = @(block,pos) (block-1)*4 + pos;
blocks    = [1 2 3];                       % only one stim period

cellstats    = table();
results_move = table();
results_stim = table();

for ch = chan_list
    for bi = 1:numel(bands)

        % ---------- cell means ----------
        for c = 1:3
            for pos = 1:4
                e = epoch_of(blocks(c),pos);
                v = log10(data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:,ch));
                cellstats = [cellstats; table(ch, string(bands{bi}), ...
                    string(cond_lab{c}), string(move_lab{pos}), e, ... data.trials.t1.psd.e1.sai.means.
                    mean(v), std(v), std(v)/sqrt(numel(v)), numel(v), ... data.trials.t1.psd.e1.sai.means.
                    'VariableNames',{'Channel','Band','Condition', ...
                    'MovementPhase','Epoch','Mean_logPower','SD','SEM','n_seconds'})];
            end
        end

        % ---------- KW: movement effect, within each condition ----------
        for c = 1:3
            vals=[]; grp=strings(1,0);
            for pos = 1:4
                e = epoch_of(blocks(c),pos);
                v = log10(data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:,ch))';
                vals=[vals,v]; grp=[grp,repmat(string(move_lab{pos}),1,numel(v))];
            end
            if numel(unique(grp)) < 2, continue; end
            [p_kw,~,st] = kruskalwallis(vals,grp,'off');
            mc = multcompare(st,'ctype','bonferroni','display','off');
            gn = string(st.gnames);
            for r = 1:size(mc,1)
                results_move = [results_move; table(ch, string(bands{bi}), ...
                    string(cond_lab{c}), p_kw, gn(mc(r,1)), gn(mc(r,2)), ...
                    mc(r,4), mc(r,6), ...
                    'VariableNames',{'Channel','Band','Condition', ...
                    'KW_omnibus_p','Group1','Group2','Estimate','Pairwise_p'})];
            end
        end

        % ---------- KW: stim effect, within each movement phase ----------
        for pos = 1:4
            vals=[]; grp=strings(1,0);
            for c = 1:3
                e = epoch_of(blocks(c),pos);
                v = log10(data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:,ch))';
                vals=[vals,v]; grp=[grp,repmat(string(cond_lab{c}),1,numel(v))];
            end
            if numel(unique(grp)) < 2, continue; end
            [p_kw,~,st] = kruskalwallis(vals,grp,'off');
            mc = multcompare(st,'ctype','bonferroni','display','off');
            gn = string(st.gnames);
            for r = 1:size(mc,1)
                results_stim = [results_stim; table(ch, string(bands{bi}), ...
                    string(move_lab{pos}), p_kw, gn(mc(r,1)), gn(mc(r,2)), ...
                    mc(r,4), mc(r,6), ...
                    'VariableNames',{'Channel','Band','MovementPhase', ...
                    'KW_omnibus_p','Group1','Group2','Estimate','Pairwise_p'})];
            end
        end
    end
end

writetable(cellstats,    's26_cell_means.csv');
writetable(results_move, 's26_stats_movement_within_condition.csv');
writetable(results_stim, 's26_stats_stim_within_movement.csv');
fprintf('cell means: %d rows | movement KW: %d rows | stim KW: %d rows\n', ...
    height(cellstats), height(results_move), height(results_stim));

% Significance counts
files  = {'s26_stats_movement_within_condition.csv','s26_stats_stim_within_movement.csv'};
labels = {'movement-within-condition','stim-within-movement'};
summary = table();
for f = 1:numel(files)
    T = readtable(files{f});
    T.sig  = T.Pairwise_p < 0.05;
    T.pair = string(T.Group1) + " vs " + string(T.Group2);
    summary = [summary; table(string(labels{f}), "ALL", "ALL", ...
        height(T), sum(T.sig), 100*mean(T.sig), ...
        'VariableNames',{'Analysis','GroupBy','Level','nTests','nSig','PctSig'})];
    for gv = {'Band','Channel','pair'}          % no StimPeriod for s26
        g  = groupsummary(T, gv{1}, 'sum','sig');
        gc = groupsummary(T, gv{1});
        for i = 1:height(g)
            summary = [summary; table(string(labels{f}), string(gv{1}), ...
                string(g.(gv{1})(i)), gc.GroupCount(i), g.sum_sig(i), ...
                100*g.sum_sig(i)/gc.GroupCount(i), ...
                'VariableNames',{'Analysis','GroupBy','Level','nTests','nSig','PctSig'})];
        end
    end
end
disp(summary); writetable(summary,'s26_significance_counts.csv');

% Build combined T for crossings and polar plots
Tm = readtable('s26_stats_movement_within_condition.csv');
Ts = readtable('s26_stats_stim_within_movement.csv');
Tm.Analysis = repmat("movement",height(Tm),1);
Ts.Analysis = repmat("stim",height(Ts),1);
Tm.HeldConstant = string(Tm.Condition);
Ts.HeldConstant = string(Ts.MovementPhase);
keep = {'Analysis','Channel','Band','HeldConstant', ...
        'Group1','Group2','Estimate','Pairwise_p','KW_omnibus_p'};
T = [Tm(:,keep); Ts(:,keep)];
T.pair = string(T.Group1) + " vs " + string(T.Group2);
T.sig  = T.Pairwise_p < 0.05;

bandpair  = sigcount(T, {'Analysis','Band','pair'});
band_chan = sigcount(T, {'Analysis','Band','Channel'});
band_held = sigcount(T, {'Analysis','Band','HeldConstant'});
disp('=== Band x comparison pair ==='); disp(bandpair)
writetable(bandpair, 's26_sig_band_by_pair.csv');
writetable(band_chan,'s26_sig_band_by_channel.csv');
writetable(band_held,'s26_sig_band_by_heldcondition.csv');

% Polar plots -> PDF
band_order = {'delta','theta','alpha','beta','gamma'};
nB = numel(band_order);
th = linspace(0, 2*pi, nB+1);

pdfout = 's26_psd_panels_2.pdf';
%if exist(pdfout,'file'), delete(pdfout); end
pg = 2;

% --- 1. overall ---
fh = figure('Name','significance by band');
pax = polaraxes; hold(pax,'on');
polarplot(pax, th, band_pct(T, T.Analysis=="movement"), '-o', ...
    'linewidth',2,'markerfacecolor','auto','DisplayName','movement effect');
polarplot(pax, th, band_pct(T, T.Analysis=="stim"), '-s', ...
    'linewidth',2,'markerfacecolor','auto','DisplayName','stim effect');
polarplot(pax, th, 5*ones(1,nB+1), 'r--','linewidth',1.5,'DisplayName','chance (5%)');
pax.ThetaTick = rad2deg(th(1:nB)); pax.ThetaTickLabel = band_order;
pax.RAxisLocation = 22;
title('Subject 26 — % of pairwise tests significant, by band');
legend('Location','southoutside','Orientation','horizontal'); hold(pax,'off');
pg = pg+1; exportgraphics(fh, pdfout, 'Append', pg>1, 'Resolution',150);

% --- 2. one polar per comparison pair ---
for a = ["movement","stim"]
    pairs = unique(T.pair(T.Analysis==a));
    fh = figure('Name',sprintf('%s — by pair',a));
    set(gcf,'Position',[60 80 1300 750])
    for k = 1:numel(pairs)
        subplot(2,ceil(numel(pairs)/2),k,polaraxes); pax = gca; hold(pax,'on');
        polarplot(pax, th, band_pct(T, T.Analysis==a & T.pair==pairs(k)), ...
            '-o','linewidth',2,'markerfacecolor','auto');
        polarplot(pax, th, 5*ones(1,nB+1), 'r--','linewidth',1);
        pax.ThetaTick = rad2deg(th(1:nB)); pax.ThetaTickLabel = band_order;
        title(pairs(k),'fontsize',10); hold(pax,'off');
    end
    sgtitle(sprintf('Subject 26 — %s effect by band, per comparison',a),'fontsize',13);
    pg = pg+1; exportgraphics(fh, pdfout, 'Append', pg>1, 'Resolution',150);
end

% --- 3. channels overlaid (6 channels) ---
for a = ["movement","stim"]
    fh = figure('Name',sprintf('%s effect by channel',a));
    pax = polaraxes; hold(pax,'on');
    cmap = lines(6);
    for ch = 1:6
        polarplot(pax, th, band_pct(T, T.Analysis==a & T.Channel==ch), ...
            '-','linewidth',1.5,'Color',cmap(ch,:),'DisplayName',sprintf('ch%d',ch));
    end
    polarplot(pax, th, 5*ones(1,nB+1),'k--','linewidth',1.5,'DisplayName','chance');
    pax.ThetaTick = rad2deg(th(1:nB)); pax.ThetaTickLabel = band_order;
    title(sprintf('Subject 26 — %s effect, band profile per channel',a));
    legend('Location','eastoutside','fontsize',8); hold(pax,'off');
    pg = pg+1; exportgraphics(fh, pdfout, 'Append', pg>1, 'Resolution',150);
end

fprintf('wrote %s (%d pages)\n', pdfout, pg);
%%
%% Subject 26 — stats only, no figures
chan_list = 1:6;
bands     = {'delta','theta','alpha','beta','gamma'};
move_lab  = {'pre','RA','LA','post'};
cond_lab  = {'Pre-Stim','Intra','Post-Stim'};
epoch_of  = @(block,pos) (block-1)*4 + pos;
blocks    = [1 2 3];                       % only one stim period

cellstats    = table();
results_move = table();
results_stim = table();

for ch = chan_list
    for bi = 1:numel(bands)

        % ---------- cell means ----------
        for c = 1:3
            for pos = 1:4
                e = epoch_of(blocks(c),pos);
                v = log10(data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:,ch));
                cellstats = [cellstats; table(ch, string(bands{bi}), ...
                    string(cond_lab{c}), string(move_lab{pos}), e, ...
                    mean(v), std(v), std(v)/sqrt(numel(v)), numel(v), ...
                    'VariableNames',{'Channel','Band','Condition', ...
                    'MovementPhase','Epoch','Mean_logPower','SD','SEM','n_seconds'})];
            end
        end

        % ---------- KW: movement effect, within each condition ----------
        for c = 1:3
            vals=[]; grp=strings(1,0);
            for pos = 1:4
                e = epoch_of(blocks(c),pos);
                v = log10(data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:,ch))';
                vals=[vals,v]; grp=[grp,repmat(string(move_lab{pos}),1,numel(v))];
            end
            if numel(unique(grp)) < 2, continue; end
            [p_kw,~,st] = kruskalwallis(vals,grp,'off');
            mc = multcompare(st,'ctype','bonferroni','display','off');
            gn = string(st.gnames);
            for r = 1:size(mc,1)
                results_move = [results_move; table(ch, string(bands{bi}), ...
                    string(cond_lab{c}), p_kw, gn(mc(r,1)), gn(mc(r,2)), ...
                    mc(r,4), mc(r,6), ...
                    'VariableNames',{'Channel','Band','Condition', ...
                    'KW_omnibus_p','Group1','Group2','Estimate','Pairwise_p'})];
            end
        end

        % ---------- KW: stim effect, within each movement phase ----------
        for pos = 1:4
            vals=[]; grp=strings(1,0);
            for c = 1:3
                e = epoch_of(blocks(c),pos);
                v = log10(data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:,ch))';
                vals=[vals,v]; grp=[grp,repmat(string(cond_lab{c}),1,numel(v))];
            end
            if numel(unique(grp)) < 2, continue; end
            [p_kw,~,st] = kruskalwallis(vals,grp,'off');
            mc = multcompare(st,'ctype','bonferroni','display','off');
            gn = string(st.gnames);
            for r = 1:size(mc,1)
                results_stim = [results_stim; table(ch, string(bands{bi}), ...
                    string(move_lab{pos}), p_kw, gn(mc(r,1)), gn(mc(r,2)), ...
                    mc(r,4), mc(r,6), ...
                    'VariableNames',{'Channel','Band','MovementPhase', ...
                    'KW_omnibus_p','Group1','Group2','Estimate','Pairwise_p'})];
            end
        end
    end
end

writetable(cellstats,    's26_cell_means.csv');
writetable(results_move, 's26_stats_movement_within_condition.csv');
writetable(results_stim, 's26_stats_stim_within_movement.csv');
fprintf('cell means: %d rows | movement KW: %d rows | stim KW: %d rows\n', ...
    height(cellstats), height(results_move), height(results_stim));

%% Significance counts
files  = {'s26_stats_movement_within_condition.csv','s26_stats_stim_within_movement.csv'};
labels = {'movement-within-condition','stim-within-movement'};
summary = table();
for f = 1:numel(files)
    T = readtable(files{f});
    T.sig  = T.Pairwise_p < 0.05;
    T.pair = string(T.Group1) + " vs " + string(T.Group2);
    summary = [summary; table(string(labels{f}), "ALL", "ALL", ...
        height(T), sum(T.sig), 100*mean(T.sig), ...
        'VariableNames',{'Analysis','GroupBy','Level','nTests','nSig','PctSig'})];
    for gv = {'Band','Channel','pair'}          % no StimPeriod for s26
        g  = groupsummary(T, gv{1}, 'sum','sig');
        gc = groupsummary(T, gv{1});
        for i = 1:height(g)
            summary = [summary; table(string(labels{f}), string(gv{1}), ...
                string(g.(gv{1})(i)), gc.GroupCount(i), g.sum_sig(i), ...
                100*g.sum_sig(i)/gc.GroupCount(i), ...
                'VariableNames',{'Analysis','GroupBy','Level','nTests','nSig','PctSig'})];
        end
    end
end
disp(summary); writetable(summary,'s26_significance_counts.csv');

%% Build combined T for crossings and polar plots
Tm = readtable('s26_stats_movement_within_condition.csv');
Ts = readtable('s26_stats_stim_within_movement.csv');
Tm.Analysis = repmat("movement",height(Tm),1);
Ts.Analysis = repmat("stim",height(Ts),1);
Tm.HeldConstant = string(Tm.Condition);
Ts.HeldConstant = string(Ts.MovementPhase);
keep = {'Analysis','Channel','Band','HeldConstant', ...
        'Group1','Group2','Estimate','Pairwise_p','KW_omnibus_p'};
T = [Tm(:,keep); Ts(:,keep)];
T.pair = string(T.Group1) + " vs " + string(T.Group2);
T.sig  = T.Pairwise_p < 0.05;

bandpair  = sigcount(T, {'Analysis','Band','pair'});
band_chan = sigcount(T, {'Analysis','Band','Channel'});
band_held = sigcount(T, {'Analysis','Band','HeldConstant'});
disp('=== Band x comparison pair ==='); disp(bandpair)
writetable(bandpair, 's26_sig_band_by_pair.csv');
writetable(band_chan,'s26_sig_band_by_channel.csv');
writetable(band_held,'s26_sig_band_by_heldcondition.csv');

%% Polar plots -> PDF
band_order = {'delta','theta','alpha','beta','gamma'};
nB = numel(band_order);
th = linspace(0, 2*pi, nB+1);

pdfout = 's26_polar_significance.pdf';
if exist(pdfout,'file'), delete(pdfout); end
pg = 0;

% --- 1. overall ---
fh = figure('Name','significance by band');
pax = polaraxes; hold(pax,'on');
polarplot(pax, th, band_pct(T, T.Analysis=="movement"), '-o', ...
    'linewidth',2,'markerfacecolor','auto','DisplayName','movement effect');
polarplot(pax, th, band_pct(T, T.Analysis=="stim"), '-s', ...
    'linewidth',2,'markerfacecolor','auto','DisplayName','stim effect');
polarplot(pax, th, 5*ones(1,nB+1), 'r--','linewidth',1.5,'DisplayName','chance (5%)');
pax.ThetaTick = rad2deg(th(1:nB)); pax.ThetaTickLabel = band_order;
pax.RAxisLocation = 22;
title('Subject 26 — % of pairwise tests significant, by band');
legend('Location','southoutside','Orientation','horizontal'); hold(pax,'off');
pg = pg+1; exportgraphics(fh, pdfout, 'Append', pg>1, 'Resolution',150);

% --- 2. one polar per comparison pair ---
for a = ["movement","stim"]
    pairs = unique(T.pair(T.Analysis==a));
    fh = figure('Name',sprintf('%s — by pair',a));
    set(gcf,'Position',[60 80 1300 750])
    for k = 1:numel(pairs)
        subplot(2,ceil(numel(pairs)/2),k,polaraxes); pax = gca; hold(pax,'on');
        polarplot(pax, th, band_pct(T, T.Analysis==a & T.pair==pairs(k)), ...
            '-o','linewidth',2,'markerfacecolor','auto');
        polarplot(pax, th, 5*ones(1,nB+1), 'r--','linewidth',1);
        pax.ThetaTick = rad2deg(th(1:nB)); pax.ThetaTickLabel = band_order;
        title(pairs(k),'fontsize',10); hold(pax,'off');
    end
    sgtitle(sprintf('Subject 26 — %s effect by band, per comparison',a),'fontsize',13);
    pg = pg+1; exportgraphics(fh, pdfout, 'Append', pg>1, 'Resolution',150);
end

% --- 3. channels overlaid (6 channels) ---
for a = ["movement","stim"]
    fh = figure('Name',sprintf('%s effect by channel',a));
    pax = polaraxes; hold(pax,'on');
    cmap = lines(6);
    for ch = 1:6
        polarplot(pax, th, band_pct(T, T.Analysis==a & T.Channel==ch), ...
            '-','linewidth',1.5,'Color',cmap(ch,:),'DisplayName',sprintf('ch%d',ch));
    end
    polarplot(pax, th, 5*ones(1,nB+1),'k--','linewidth',1.5,'DisplayName','chance');
    pax.ThetaTick = rad2deg(th(1:nB)); pax.ThetaTickLabel = band_order;
    title(sprintf('Subject 26 — %s effect, band profile per channel',a));
    legend('Location','eastoutside','fontsize',8); hold(pax,'off');
    pg = pg+1; exportgraphics(fh, pdfout, 'Append', pg>1, 'Resolution',150);
end

fprintf('wrote %s (%d pages)\n', pdfout, pg);
function out = sigcount(T, vars)
g  = groupsummary(T, vars, 'sum', 'sig');
gc = groupsummary(T, vars);
out = g(:,vars);
out.nTests = gc.GroupCount;
out.nSig   = g.sum_sig;
out.PctSig = 100*g.sum_sig./gc.GroupCount;
out = sortrows(out,'PctSig','descend');
end

function r = band_pct(T, mask)
band_order = {'delta','theta','alpha','beta','gamma'};
r = zeros(1,numel(band_order)+1);
for b = 1:numel(band_order)
    sel = mask & T.Band==string(band_order{b});
    if any(sel), r(b) = 100*mean(T.Pairwise_p(sel) < 0.05); end
end
r(end) = r(1);
end


%%
cols = lines(nch);
ch_labels = arrayfun(@(ch) sprintf('Ch %d',ch), 1:nch, 'UniformOutput', false);

for c = 1:3
    figure('Name', cond_labels{c})
    for k = 1:4
        subplot(2,2,k); hold on
        e = p.(sprintf('e%d', k + (c-1)*4));
        for ch = 1:nch
            plot(p.freq(1:206), log10(e.saw(1:206,ch)), ...
                'LineWidth', 1.5, 'Color', cols(ch,:));
        end
        xlim([0 200])
        xlabel('Hz'); ylabel('log power')
        title(mv_titles{k})
        if k == 1, legend(ch_labels, 'Location','best'); end
    end
    sgtitle(cond_labels{c})
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WANT THIS IN FIGURE PLOT %% 24 FIGURES: 2 per channel per stim period — movement-state and stim-state, with KW stars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bands        = {'delta','theta','alpha','beta','gamma'};
band_titles  = {'Delta','Theta','Alpha','Beta','Gamma'};
phase_names  = {'Pre-move','RA Flex','LA Flex','Post-move'};
move_labels  = {'pre','R','L','post'};
stim_labels  = {'pre','intra','post'};
stim_type    = {'Anodal','Cathodal'};            % stim period 1 and 2
epoch_of     = @(block,pos) (block-1)*4 + pos;   % 20 epochs = 5 blocks x 4 positions

% blocks per stim period:  n=1 -> [1 2 3] (no-stim, anodal, rest2)
%                          n=2 -> [3 4 5] (rest2, cathodal, rest3)
% note post-stim of the anodal period IS the pre-stim of the cathodal period
pdfout = "s26_all_stims_raw.pdf";
for n = 1:2                                       % <-- stim period loop
    blocks = [2*n-1, 2*n, 2*n+1];
    stim_names = {sprintf('Pre-%s',stim_type{n}), ...
        sprintf('Intra 2.0mA %s',stim_type{n}), ...
        sprintf('Post-%s',stim_type{n})};

    % ============ FIGURE 1 per channel: MOVEMENT state (4 bars), columns = stim state ============
    for ch = 1:6
        fh4 = figure('Name',sprintf('ch%d %s movement state',ch,stim_type{n}));
        set(gcf,'Position',[60 30 1000 1050])
        for bi = 1:5
            for st = 1:3
                subplot(5,3,(bi-1)*3 + st); hold on
                vals = []; grp = strings(1,0); mn = zeros(1,4); sem = zeros(1,4);
                for c = 1:4
                    e = epoch_of(blocks(st),c);
                    v = data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:, ch);
                    v = log10(v(:))';
                    vals = [vals, v];
                    grp  = [grp, repmat(string(move_labels{c}),1,numel(v))];
                    mn(c) = mean(v); sem(c) = std(v)/sqrt(numel(v));
                end
                [p_kw,~,kwst] = kruskalwallis(vals, grp, 'off');
                mc = multcompare(kwst,'ctype','bonferroni','display','off');
                lo = min(mn-sem); hi = max(mn+sem); rg = hi-lo; if rg==0, rg=0.1; end
                b = bar(1:4, mn); b.BaseValue = lo - 0.20*rg;
                errorbar(1:4, mn, sem, 'k','linestyle','none','linewidth',1);
                ylim([lo-0.20*rg, hi+0.50*rg]);
                set(gca,'xtick',1:4,'xticklabel',move_labels);
                sig = mc(mc(:,6)<0.05,:);
                if ~isempty(sig)
                    drawSig(arrayfun(@(k){[sig(k,1) sig(k,2)]},1:size(sig,1)), sig(:,6));
                end
                if bi==1, title(sprintf('%s\np=%.3g',stim_names{st},p_kw),'fontsize',9);
                else,     title(sprintf('p=%.3g',p_kw),'fontsize',8); end
                if st==1, ylabel(sprintf('%s\nlog power',band_titles{bi}),'fontsize',9); end
                hold off
            end
        end
        sgtitle(sprintf('Channel %d — %s — movement effect within each stimulation state', ...
            ch, stim_type{n}));
        exportgraphics(fh4, pdfout, "Append", true, "Resolution", 150)
        close(fh4)
    end

    % ============ FIGURE 2 per channel: STIM state (3 bars), columns = movement phase ============
    for ch = 1:6
        fh5 = figure('Name',sprintf('ch%d %s stim state',ch,stim_type{n}));
        set(gcf,'Position',[60 30 1150 1050])
        for bi = 1:5
            for ph = 1:4
                subplot(5,4,(bi-1)*4 + ph); hold on
                vals = []; grp = strings(1,0); mn = zeros(1,3); sem = zeros(1,3);
                for c = 1:3
                    e = epoch_of(blocks(c),ph);
                    v = data.trials.t1.psd.(['e' num2str(e)]).sai.means.(bands{bi})(:, ch);
                    v = log10(v(:))';
                    vals = [vals, v];
                    grp  = [grp, repmat(string(stim_labels{c}),1,numel(v))];
                    mn(c) = mean(v); sem(c) = std(v)/sqrt(numel(v));
                end
                [p_kw,~,kwst] = kruskalwallis(vals, grp, 'off');
                mc = multcompare(kwst,'ctype','bonferroni','display','off');
                lo = min(mn-sem); hi = max(mn+sem); rg = hi-lo; if rg==0, rg=0.1; end
                b = bar(1:3, mn); b.BaseValue = lo - 0.20*rg;
                errorbar(1:3, mn, sem, 'k','linestyle','none','linewidth',1);
                ylim([lo-0.20*rg, hi+0.50*rg]);
                set(gca,'xtick',1:3,'xticklabel',stim_labels);
                sig = mc(mc(:,6)<0.05,:);
                if ~isempty(sig)
                    drawSig(arrayfun(@(k){[sig(k,1) sig(k,2)]},1:size(sig,1)), sig(:,6));
                end
                if bi==1, title(sprintf('%s\np=%.3g',phase_names{ph},p_kw),'fontsize',9);
                else,     title(sprintf('p=%.3g',p_kw),'fontsize',8); end
                if ph==1, ylabel(sprintf('%s\nlog power',band_titles{bi}),'fontsize',9); end
                hold off
            end
        end
        sgtitle(sprintf('Channel %d — %s — stimulation effect within each movement phase', ...
            ch, stim_type{n}));
        exportgraphics(fh5, pdfout, "Append", true, "Resolution", 150) 
        close(fh5)
    end

end   % <-- end stim period loop

%%
%% PSD panels — 1 figure per channel, both slicings, both stim periods
NF          = 206;                                  % freq points (~0-200 Hz)
phase_names = {'Pre-move','RA Flex','LA Flex','Post-move'};
move_lab    = {'pre','R','L','post'};
stim_lab    = {'pre','intra','post'};
stim_type   = {'Anodal','Cathodal'};
epoch_of    = @(block,pos) (block-1)*4 + pos;
FIELD       = 'sawRAW';                                % 'saw' = CAR, 'sawRAW' = no CAR

pdfout = 's26_all_stims_raw.pdf';
if exist(pdfout,'file'), delete(pdfout); end
pg = 0;

for ch = 1:6
    fh = figure('Name',sprintf('ch%d PSD panels',ch));
    set(gcf,'Position',[30 20 1500 1100])

    for n = 1:2                                     % stim period -> row pair
        blocks = [2*n-1, 2*n, 2*n+1];
        stim_names = {sprintf('Pre-%s',stim_type{n}), ...
            sprintf('Intra %s',stim_type{n}), ...
            sprintf('Post-%s',stim_type{n})};

        % ---- row 1 of pair: one panel per MOVEMENT state, 3 stim lines ----
        for pos = 1:4
            subplot(4,4,(n-1)*8 + pos); hold on
            for c = 1:3
                e = epoch_of(blocks(c),pos);
                plot(data.trials.t1.psd.freq(1:NF), ...
                    log10(data.trials.t1.psd.(['e' num2str(e)]).(FIELD)(1:NF,ch)), ...
                    'linewidth',1.2);
            end
            title(sprintf('%s — %s',stim_type{n},phase_names{pos}),'fontsize',9);
            if pos==1
                ylabel('log power','fontsize',9);
                legend(stim_names,'fontsize',6,'location','southwest');
            end
            xlabel('Hz','fontsize',8); grid on; hold off
        end

        % ---- row 2 of pair: one panel per STIM state, 4 movement lines ----
        for c = 1:3
            subplot(4,4,(n-1)*8 + 4 + c); hold on
            for pos = 1:4
                e = epoch_of(blocks(c),pos);
                plot(data.trials.t1.psd.freq(1:NF), ...
                    log10(data.trials.t1.psd.(['e' num2str(e)]).(FIELD)(1:NF,ch)), ...
                    'linewidth',1.2);
            end
            title(stim_names{c},'fontsize',9);
            if c==1
                ylabel('log power','fontsize',9);
                legend(phase_names,'fontsize',6,'location','southwest');
            end
            xlabel('Hz','fontsize',8); grid on; hold off
        end
    end

    sgtitle(sprintf('Channel %d — PSD by movement state (rows 1,3) and by stimulation state (rows 2,4)', ch), ...
        'fontsize',13);
    pg = pg+1; exportgraphics(fh, pdfout, 'Append', pg>1, 'Resolution',150);
end
fprintf('wrote %s (%d pages)\n', pdfout, pg);