%% cfg 
data.cfg.info.n_sbj='21';
data.cfg.info.i_chan=[1 2 3 4 5 6];
data.cfg.info.dx='pd';
data.cfg.info.Fs=1000;

data.cfg.trial_data.t1.filename=["/Users/terry/OneDrive - Medical University of South Carolina/Suresh, Rishishankar's files - ECOG + DBS (PD)/data/ECOG_analysis/Unprocessed_data/pro00073545_0021/ecog/VRP_021-200526-100415"];

% freq bands
frq_band_txt{1}='delta';
frq_band_txt{2}='theta';
frq_band_txt{3}='alpha';
frq_band_txt{4}='beta';
frq_band_txt{5}='gamma_l';
frq_band_txt{6}='gamma_bb';
frq_band_ind{1}=['2:3'];
frq_band_ind{2}=['3:5'];
frq_band_ind{3}=['5:7'];
frq_band_ind{4}=['8:16'];
frq_band_ind{5}=['16:27'];
frq_band_ind{6}=['37:103'];

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
hold on; plot(temp.t1.sig.ecog(:,2)/1e7+1e-10)



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
    eval(['plot(data.trials.t',num2str(i),'.sig.amps(:,1))']);
    legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6','sync','trig','amps')
    %title(eval(['data.cfg.trial_data.t',num2str(i),'.cond']))
end
%%
%define epochs - remove 4 and renumber to 21, rerun the whole script and
%look at beta
data.trials.t1.epochs.e1(1,1)=8.04e4; %No movement no stim
data.trials.t1.epochs.e1(1,2)=1.05e5; 
data.trials.t1.epochs.e2(1,1)=1.077e5; %No stim R Arm Flex
data.trials.t1.epochs.e2(1,2)=1.19e5;
data.trials.t1.epochs.e3(1,1)=1.22e5; %No stim Post-Move
data.trials.t1.epochs.e3(1,2)=1.50e5; 
data.trials.t1.epochs.e4(1,1)=1.85e5; %0.5 Pre-Move
data.trials.t1.epochs.e4(1,2)=2.05e5;
data.trials.t1.epochs.e5(1,1)=2.14e5; %0.5 R Arm Flex
data.trials.t1.epochs.e5(1,2)=2.28e5;
data.trials.t1.epochs.e6(1,1)=2.3e5; %0.5 Post-Move
data.trials.t1.epochs.e6(1,2)=2.4e5;
data.trials.t1.epochs.e7(1,1)=2.8e5; %No stim Pre-move
data.trials.t1.epochs.e7(1,2)=3.1e5; 
data.trials.t1.epochs.e8(1,1)=3.38e5; %No stim R Arm Flex
data.trials.t1.epochs.e8(1,2)=3.48e5;
data.trials.t1.epochs.e9(1,1)=3.5e5; % No stim Post Arm Flex
data.trials.t1.epochs.e9(1,2)=3.8e5;
data.trials.t1.epochs.e10(1,1)=4.25e5; %1.0 Stim Pre-Move
data.trials.t1.epochs.e10(1,2)=4.55e5;
data.trials.t1.epochs.e11(1,1)=4.57e5; %1.0 Stim R Arm Flex
data.trials.t1.epochs.e11(1,2)=4.70e5;
data.trials.t1.epochs.e12(1,1)=4.705e5; %1.0 Post-Move
data.trials.t1.epochs.e12(1,2)=4.8e5; 
data.trials.t1.epochs.e13(1,1)=5.15e5; % No stim Rest Pre-Move
data.trials.t1.epochs.e13(1,2)=5.45e5; 
data.trials.t1.epochs.e14(1,1)=5.73e5; % No stim R Arm Flex
data.trials.t1.epochs.e14(1,2)=5.87e5;
data.trials.t1.epochs.e15(1,1)=6.0e5; % No stim Post-Move
data.trials.t1.epochs.e15(1,2)=6.3e5;
data.trials.t1.epochs.e16(1,1)=6.65e5; % 1.5 Pre-Move
data.trials.t1.epochs.e16(1,2)=6.9e5;
data.trials.t1.epochs.e17(1,1)=6.93e5; % 1.5 R Arm Flex
data.trials.t1.epochs.e17(1,2)=7.07e5;
data.trials.t1.epochs.e18(1,1)=7.1e5; % 1.5 Post-Move
data.trials.t1.epochs.e18(1,2)=7.2e5;
data.trials.t1.epochs.e19(1,1)=7.6e5; % No Stim Pre-Move
data.trials.t1.epochs.e19(1,2)=7.9e5;
data.trials.t1.epochs.e20(1,1)=8.15e5; % No stim R Arm Flex
data.trials.t1.epochs.e20(1,2)=8.27e5;
data.trials.t1.epochs.e21(1,1)=8.35e5; % No stim Post-Move
data.trials.t1.epochs.e21(1,2)=8.65e5;
data.trials.t1.epochs.e22(1,1)=9.05e5; %2.0 Pre-Move
data.trials.t1.epochs.e22(1,2)=9.2e5;
data.trials.t1.epochs.e23(1,1)=9.22e5; %2.0 R Arm Flex
data.trials.t1.epochs.e23(1,2)=9.38e5;
data.trials.t1.epochs.e24(1,1)=9.45e5; %2.0 Post-Move
data.trials.t1.epochs.e24(1,2)=9.60e5;
data.trials.t1.epochs.e25(1,1)=9.95e5; % No stim Pre-Move
data.trials.t1.epochs.e25(1,2)=10.25e5;
data.trials.t1.epochs.e26(1,1)=10.62e5; % No stim R Arm Flex
data.trials.t1.epochs.e26(1,2)=10.77e5;
data.trials.t1.epochs.e27(1,1)=10.80e5; % No stim Post-Move
data.trials.t1.epochs.e27(1,2)=11.05e5;
data.trials.t1.epochs.e28(1,1)=11.55e5; % 2.0 Cath Pre-Move
data.trials.t1.epochs.e28(1,2)=11.7e5;
data.trials.t1.epochs.e29(1,1)=11.75e5; % 2.0 Cath R Arm Flex
data.trials.t1.epochs.e29(1,2)=11.91e5; 
data.trials.t1.epochs.e30(1,1)=11.95e5; % 2.0 Cath Post-Move
data.trials.t1.epochs.e30(1,2)=12.02e5; 
data.trials.t1.epochs.e31(1,1)=12.4e5; % No stim Pre-Move
data.trials.t1.epochs.e31(1,2)=12.7e5;
data.trials.t1.epochs.e32(1,1)=12.95e5; % No stim R Arm Flex
data.trials.t1.epochs.e32(1,2)=13.077e5;
data.trials.t1.epochs.e33(1,1)=13.2e5; % No stim Post-Move
data.trials.t1.epochs.e33(1,2)=13.5e5;




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
        eval(['plot(data.trials.t',num2str(i),'.sig.ecog(:,',num2str(j),')*10+j*1e-2)']); hold on
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
        '.sig.ecog([data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1):data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)],:),512,[],1024,1000);']);
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
        eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:103),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw(1:103,:)))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
            legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6')
            title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
            
            
        %end
    end
end
%%
figure;
set(gcf,'Position',[100 10 560 740])
dim = [.1 .65 .3 .3];
annotation('textbox',dim,'String','t1:e1:60s rest','FitBoxToText','on');
dim = [.1 .60 .3 .3];
annotation('textbox',dim,'String','t1:e2:Left Anodal tdcs 0.5mA 60 sec-1','FitBoxToText','on');
dim = [.1 .55 .3 .3];
annotation('textbox',dim,'String','t1:e3:Left Anodal tdcs 0.5mA 60 sec-2','FitBoxToText','on');
dim = [.1 .50 .3 .3];
annotation('textbox',dim,'String','t1:e4:2 min rest-1','FitBoxToText','on');
dim = [.1 .45 .3 .3];
annotation('textbox',dim,'String','t1:e5:2 min rest-2','FitBoxToText','on');
dim = [.1 .40 .3 .3];
annotation('textbox',dim,'String','t1:e6:Left Anodal tdcs 1.0mA 60 sec-1','FitBoxToText','on');
dim = [.1 .35 .3 .3];
annotation('textbox',dim,'String','t1:e7:Left Anodal tdcs 1.0mA 60 sec-2','FitBoxToText','on');
dim = [.1 .30 .3 .3];
annotation('textbox',dim,'String','t1:e8:2 min rest-1','FitBoxToText','on');
dim = [.1 .25 .3 .3];
annotation('textbox',dim,'String','t1:e9:2 min rest-2','FitBoxToText','on');
dim = [.1 .20 .3 .3];
annotation('textbox',dim,'String','t1:e10:Left Anodal tdcs 1.5mA 60 sec-1','FitBoxToText','on');
dim = [.1 .15 .3 .3];
annotation('textbox',dim,'String','t1:e11:Left Anodal tdcs 1.5mA 60 sec-2 - MOVE','FitBoxToText','on');
dim = [.1 .10 .3 .3];
annotation('textbox',dim,'String','t1:e12:2 min rest-1','FitBoxToText','on');
dim = [.1 .05 .3 .3];
annotation('textbox',dim,'String','t1:e13:2 min rest-1','FitBoxToText','on');

figure;
set(gcf,'Position',[100 10 560 740])
dim = [.1 .65 .3 .3];
annotation('textbox',dim,'String','t1:e14:Left Anodal tdcs 2.0mA 60 sec-1','FitBoxToText','on');
dim = [.1 .60 .3 .3];
annotation('textbox',dim,'String','t1:e15:Left Anodal tdcs 2.0mA 60 sec-2 - MOVE','FitBoxToText','on');
dim = [.1 .55 .3 .3];
annotation('textbox',dim,'String','t1:e16:2 min rest-1','FitBoxToText','on');
dim = [.1 .50 .3 .3];
annotation('textbox',dim,'String','t1:e17:2 min rest-2','FitBoxToText','on');
dim = [.1 .45 .3 .3];
annotation('textbox',dim,'String','t1:e18:Left Cathodal tdcs 2.0mA 60 sec-1','FitBoxToText','on');
dim = [.1 .40 .3 .3];
annotation('textbox',dim,'String','t1:e19:Left Cathodal tdcs 2.0mA 60 sec-2','FitBoxToText','on');
dim = [.1 .35 .3 .3];
annotation('textbox',dim,'String','t1:e20:2 min rest-1','FitBoxToText','on');
dim = [.1 .30 .3 .3];
annotation('textbox',dim,'String','t1:e21:2 min rest-2','FitBoxToText','on');
dim = [.1 .25 .3 .3];
%annotation('textbox',dim,'String','t1:e22:Left Anodal tdcs 2mA 2 min-1','FitBoxToText','on');
%dim = [.1 .20 .3 .3];
%annotation('textbox',dim,'String','t1:e23:Left Anodal tdcs 2mA 2 min-2','FitBoxToText','on');
%dim = [.1 .15 .3 .3];
%annotation('textbox',dim,'String','t1:e24:60s - 1','FitBoxToText','on');
%dim = [.1 .10 .3 .3];
%annotation('textbox',dim,'String','t1:e25:60s - 2','FitBoxToText','on');


% plot psd curves - separate by channel - all epochs overlaid
spi=[1,3,5,7,9,11];

for i=1:size(mat_trial_epoch,1)
    figure
    set(gcf,'Position',[100 10 560 740])
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(data.cfg.info.i_chan,2)
            subplot(6,2,spi(k))
            hold on
            if k==1
                title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])
                
            end
            eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:103),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw(1:103,',num2str(k),')))'])
            ylabel(['ch',num2str(k)])
            if k==6
                xlabel('Hz')
            end
        end
    end
    subplot(6,2,1)
    epoch_names_all=eval(['fieldnames(data.trials.t',num2str(i),'.psd);']);
    epoch_names_e=epoch_names_all(strncmp(epoch_names_all,'e',1),:);
    legend(epoch_names_e)
end

%%
% calculate psd in 1-sec segments of each epoch

% delta(2-3)        1-4 Hz
% theta(3-5)        4-8 Hz
% alpha(5-7)       8-12 Hz
% beta(8-16)       13-30 Hz
% gamma_low(16-27)  30-50 Hz
% gamma_bb(37-103)  70-200 Hz

for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:eval(['(data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)-data.trials.t',...
                num2str(i),'.epochs.e',num2str(j),'(1))/1000'])
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
                num2str(i),'.sig.ecog([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs.e',num2str(j),...
                '(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1)],:),512,0.5,512,1000);']);
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

%% stats

% calculate groups
for i=1% here i is serving just for the counter
    count=0
    for j=mat_trial_epoch(:,1)'
        for k=1:mat_trial_epoch(j,3)
            count=count+1
            eval(['mat_sz_epoch{',num2str(count),'}=linspace(',num2str(count),',',num2str(count),...
                ',size(data.trials.t',num2str(mat_trial_epoch(j,2)),'.psd.e',num2str(k),'.sai.vals,1));'])
        end
    end
end
grp_epochs=cat(2,mat_sz_epoch{:});

% %%% another way to do it
% grp_epochs=0
% for i=1:size(mat_sz_epoch,2)
%     if i==1
%         grp_epochs(1:size(mat_sz_epoch{i},2))=mat_sz_epoch{i};
%     else
%         grp_epochs(size(grp_epochs,2)+1:size(grp_epochs,2)+size(mat_sz_epoch{i},2))=mat_sz_epoch{i};
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%

% rearrange means by frq band and channel
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:size(frq_band_ind,2)
            for l=1:size(data.cfg.info.i_chan,2)                
                eval(['mat_stat_means.t',num2str(i),'.e',num2str(j),'.',frq_band_txt{k},'.c',num2str(l),'=data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.means.',frq_band_txt{k},'(:,',num2str(l),');']);
            end
        end
    end
end

for i=1:size(frq_band_ind,2)
    for j=1:size(data.cfg.info.i_chan,2)   
    count=0;
        for k=1:size(mat_trial_epoch,1)
            for l=1:mat_trial_epoch(k,3)
                count=count+1;
                eval(['mat_stat_means.',frq_band_txt{i},'.c',num2str(j),'{count}=data.trials.t',...
                num2str(k),'.psd.e',num2str(l),'.sai.means.',frq_band_txt{i},'(:,',num2str(j),');']);
            end
        end
    end
end

for i=1:size(frq_band_ind,2)
    for j=1:size(data.cfg.info.i_chan,2)  
        eval(['data.stats.psd.means.',frq_band_txt{i},'.c',num2str(j),'=cat(1,mat_stat_means.',frq_band_txt{i},'.c',num2str(j),'{:})''']);
    end
end
    
%calculate statistic and corrected p-values
for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        eval(['[data.stats.psd.test.kw.p.',frq_band_txt{i},'.c',num2str(j),...
            ',data.stats.psd.test.kw.anovatab.',frq_band_txt{i},'.c',num2str(j),...
            ',data.stats.psd.test.kw.stats.',frq_band_txt{i},'.c',num2str(j),...
            ']= kruskalwallis(data.stats.psd.means.',frq_band_txt{i},'.c',num2str(j),...
            ',grp_epochs,''off'')'])
    end
end

for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        eval(['data.stats.psd.test.kw.mc.',frq_band_txt{i},'.c',num2str(j),'= multcompare(data.stats.psd.test.kw.stats.',frq_band_txt{i},'.c',num2str(j),',''ctype'',''bonferroni'')'])
    end
end

for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        eval(['mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}=find(data.stats.psd.test.kw.mc.',frq_band_txt{i},'.c',num2str(j),'(:,6)<0.05)'])
    end
end

data.stats.psd.test.kw.p_corr=[];
for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        if isempty(data.stats.psd.test.kw.p_corr)==1
            eval(['data.stats.psd.test.kw.p_corr=linspace(',num2str(i),',',num2str(i),...
                ',length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats.psd.test.kw.p_corr(:,2)=linspace(',num2str(j),',',num2str(j),...
                ',length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats.psd.test.kw.p_corr(:,3)=data.stats.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},1);'])
            eval(['data.stats.psd.test.kw.p_corr(:,4)=data.stats.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},2);'])
            eval(['data.stats.psd.test.kw.p_corr(:,5)=data.stats.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},6);'])
        else
            size_p_corr=size(data.stats.psd.test.kw.p_corr,1); 
            eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),1)=linspace(',num2str(i),',',num2str(i),...
                ',length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),2)=linspace(',num2str(j),',',num2str(j),...
                ',length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}))'';']);
            eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),3)=data.stats.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},1);'])
            eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),4)=data.stats.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},2);'])
            eval(['data.stats.psd.test.kw.p_corr(size_p_corr+1:size_p_corr+length(mc_find.',frq_band_txt{i},'.p_corr{',num2str(j),'}),5)=data.stats.psd.test.kw.mc.',...
                frq_band_txt{i},'.c',num2str(j),'(mc_find.',frq_band_txt{i},'.p_corr{j},6);'])
        end
    end
end

%also I would calculate the most frequently seen epoch pairing within the
%corrected p-values as well as the most frequently seen frequency range and
%channel
data.stats.psd.test.kw.p_corr_mets.frq(1,1)=1;
data.stats.psd.test.kw.p_corr_mets.frq(1,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==1),1);
data.stats.psd.test.kw.p_corr_mets.frq(2,1)=2;
data.stats.psd.test.kw.p_corr_mets.frq(2,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==2),1);
data.stats.psd.test.kw.p_corr_mets.frq(3,1)=3;
data.stats.psd.test.kw.p_corr_mets.frq(3,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==3),1);
data.stats.psd.test.kw.p_corr_mets.frq(4,1)=4;
data.stats.psd.test.kw.p_corr_mets.frq(4,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==4),1);
data.stats.psd.test.kw.p_corr_mets.frq(5,1)=5;
data.stats.psd.test.kw.p_corr_mets.frq(5,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==5),1);
data.stats.psd.test.kw.p_corr_mets.frq(6,1)=6;
data.stats.psd.test.kw.p_corr_mets.frq(6,2)=size(find(data.stats.psd.test.kw.p_corr(:,1)==6),1);

data.stats.psd.test.kw.p_corr_mets.ch(1,1)=1;
data.stats.psd.test.kw.p_corr_mets.ch(1,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==1),1);
data.stats.psd.test.kw.p_corr_mets.ch(2,1)=2;
data.stats.psd.test.kw.p_corr_mets.ch(2,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==2),1);
data.stats.psd.test.kw.p_corr_mets.ch(3,1)=3;
data.stats.psd.test.kw.p_corr_mets.ch(3,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==3),1);
data.stats.psd.test.kw.p_corr_mets.ch(4,1)=4;
data.stats.psd.test.kw.p_corr_mets.ch(4,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==4),1);
data.stats.psd.test.kw.p_corr_mets.ch(5,1)=5;
data.stats.psd.test.kw.p_corr_mets.ch(5,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==5),1);
data.stats.psd.test.kw.p_corr_mets.ch(6,1)=6;
data.stats.psd.test.kw.p_corr_mets.ch(6,2)=size(find(data.stats.psd.test.kw.p_corr(:,2)==6),1);
%% plots
try data = data_pro00073545_s021; catch; end
%prepare supermeans and errorbars for plotting - arranged by epoch and
%channel
for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
    count=0
        for k=mat_trial_epoch(:,1)'
            for l=1:mat_trial_epoch(k,3)
                count=count+1;
                eval(['data.plots.',frq_band_txt{i},'.c',num2str(j),...
                    '.supermeans(',num2str(count),')=data.trials.t',...
                    num2str(mat_trial_epoch(k,2)),'.psd.e',num2str(l),...
                    '.sai.supermeans.',frq_band_txt{i},'(',num2str(j),')'])
                eval(['data.plots.',frq_band_txt{i},'.c',num2str(j),...
                    '.ses(',num2str(count),')=data.trials.t',...
                    num2str(mat_trial_epoch(k,2)),'.psd.e',num2str(l),...
                    '.sai.ses.',frq_band_txt{i},'(',num2str(j),')'])
            end
        end
    clear count
    end
end

%plot supermeans and errorbars 
for i=1:size(frq_band_txt,2)
    for j=1:size(data.cfg.info.i_chan,2)
        if j==1
            figure
            set(gcf,'Position',[100 10 560 740])
        end
            subplot(size(data.cfg.info.i_chan,2),2,spi(j))
            eval(['bar([data.plots.',frq_band_txt{i},'.c',num2str(j),'.supermeans])']);hold on
            eval(['errorbar(data.plots.',frq_band_txt{i},'.c',num2str(j),'.supermeans,data.plots.',frq_band_txt{i},'.c',num2str(j),'.ses,''.k'')'])
            ylabel(['ch',num2str(j)])
        if j==1
            title(['s14 all epochs ',frq_band_txt{i}])
        elseif j==size(data.cfg.info.i_chan,2)
            xlabel('epochs')
        end
    end
end
%%
data_pro00073545_s021=data;
save('data_pro00073545_021','data_pro00073545_s021')

%% kw verification



epoch_stats_gr_all_1_7 = [data.trials.t1.psd.e1.sai.means.beta(:, 4)'...
data.trials.t1.psd.e2.sai.means.beta(:, 4)'...
data.trials.t1.psd.e3.sai.means.beta(:, 4)'...
data.trials.t1.psd.e4.sai.means.beta(:, 4)'...
data.trials.t1.psd.e5.sai.means.beta(:, 4)'...
data.trials.t1.psd.e6.sai.means.beta(:, 4)'...
data.trials.t1.psd.e7.sai.means.beta(:, 4)'];




grping = [repmat("a",1,24)...
repmat("b",1,11)...
repmat("c",1,28)... 
repmat("d",1,20)...
repmat("e",1,14)...
repmat("f",1,10)...
repmat("g",1,30)];


[p,anovatab,stats] = kruskalwallis(epoch_stats_gr_all_1_7, grping, 'off');


kw_mult_output = multcompare(stats, 'ctype', 'bonferroni');

writematrix(epoch_stats_gr_all_1_7, 'epoch_stats_matlab_output');
hold on
bar([data.plots.beta.c4.supermeans]);
lines = kw_mult_output(find(kw_mult_output(:,6)<0.05), :);

for i=1:size(lines, 1)
    sigstar([lines(1) lines(2)]);
end
errorbar(data.plots.beta.c4.supermeans,data.plots.beta.c4.ses, '.k')
           ylabel(['ch',4])

hold off



    % x=[1,2,3,2,1];
    % subplot(1,2,1)
    % bar(x)
    % sigstar({[1,2], [2,3], [4,5]})
    % subplot(1,2,2)
    % bar(x)
    % sigstar({[2,3],[1,2], [4,5]})

% [p,anovatab,stats] = kruskalwallis(epoch_stats_gr_all_7_13, grping, 'off');
% kw_mult_output = multcompare(stats, 'ctype', 'bonferroni')
%%epoch -- frequency -- channel

%% Channel Chooser
freqs = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma_l', "Gamma_bb"};
stim = {"0.5 mA Anodal", "1.0 mA Anodal", "1.5 mA Anodal", "2.0 mA Anodal", "2.0 mA Cathodal"};
section = {1:9, 7:15, 13:21, 19:27, 25:33};


figure
% clear p anovatab stats
epselect = 4;
ch = 5;



ep = section{epselect};

freq = freqs{4};

chname = 'c' + string(ch);

matcreator = repmat("e", 1, length(ep));
resultarr = strings(size(length(ep)));
for i = 1:length(ep)
    resultarr(i) = matcreator(i) + ep(i);
end

grping = [repmat("a", 1, size(data.trials.t1.psd.(resultarr(1)).sai.means.(lower(freq))(:, ch), 1))...
    repmat("b", 1, size(data.trials.t1.psd.(resultarr(2)).sai.means.(lower(freq))(:, ch), 1))...
    repmat("c", 1, size(data.trials.t1.psd.(resultarr(3)).sai.means.(lower(freq))(:, ch), 1))...
    repmat("d", 1, size(data.trials.t1.psd.(resultarr(4)).sai.means.(lower(freq))(:, ch), 1))...
    repmat("e", 1, size(data.trials.t1.psd.(resultarr(5)).sai.means.(lower(freq))(:, ch), 1))...
    repmat("f", 1, size(data.trials.t1.psd.(resultarr(6)).sai.means.(lower(freq))(:, ch), 1))...
    repmat("g", 1, size(data.trials.t1.psd.(resultarr(7)).sai.means.(lower(freq))(:, ch), 1))...
    repmat("h", 1, size(data.trials.t1.psd.(resultarr(8)).sai.means.(lower(freq))(:, ch), 1))...
    repmat("k", 1, size(data.trials.t1.psd.(resultarr(9)).sai.means.(lower(freq))(:, ch), 1))...
];
epoch_stats_gr_all_7_13 = [data.trials.t1.psd.(resultarr(1)).sai.means.(lower(freq))(:, ch)'...
data.trials.t1.psd.(resultarr(2)).sai.means.(lower(freq))(:, ch)'...
data.trials.t1.psd.(resultarr(3)).sai.means.(lower(freq))(:, ch)'...
data.trials.t1.psd.(resultarr(4)).sai.means.(lower(freq))(:, ch)'...
data.trials.t1.psd.(resultarr(5)).sai.means.(lower(freq))(:, ch)'...
data.trials.t1.psd.(resultarr(6)).sai.means.(lower(freq))(:, ch)'...
data.trials.t1.psd.(resultarr(7)).sai.means.(lower(freq))(:, ch)'...
data.trials.t1.psd.(resultarr(8)).sai.means.(lower(freq))(:, ch)'...
data.trials.t1.psd.(resultarr(9)).sai.means.(lower(freq))(:, ch)'];

colorMatrix = [0.2 0.2 0.7;     % Blue
.2 0.67 .2;     % Green
.67 .2 .2;      % Red
0.2 0.2 0.7;    % Blue
.2 0.67 .2;     % Green 
.67 0.2 .2;     % Red
0.2 0.2 0.7;    % Blue
.2 0.67 .2;     % Green 
.67 0.2 .2;     % Red
];
                




[p,anovatab,stats] = kruskalwallis(epoch_stats_gr_all_7_13, grping, 'off');
kw_mult_output = multcompare(stats, 'ctype', 'bonferroni', 'Display', 'off');

eval(sprintf('data.stats.psd.test.kw.mc.kwmultoutput_c%d_e%d_%s=multcompare(stats, ''ctype'', ''bonferroni'', ''Display'', ''off'');', ch, epselect, freq));


hold on
bar([data.plots.(lower(freq)).(chname).supermeans(ep)], 'FaceColor', 'flat', 'CData', colorMatrix);
lines = kw_mult_output(find(kw_mult_output(:,6)<0.05), :);
for i=1:size(lines, 1)
    line = lines(i, :);
    sigstar([line(1) line(2)], line(6));

end
%chname
errorbar(data.plots.(lower(freq)).(chname).supermeans(ep),data.plots.(lower(freq)).(chname).ses(ep), '.k')
           ylabel([freq ' Power']);
           xlabel('Epoch');
           title(['Channel ' num2str(ch) ' '  freq ' Power By Epoch '  char(stim{epselect}) ' Stimulation']);
           xticks([1:9]);
           xticklabels(ep);
        


% --- Vertical reference lines with legend handles ---
hStart = xline(3.5, '--g', 'LineWidth', 2); % green dashed line
hStop  = xline(6.5, '--r', 'LineWidth', 2); % red dashed line

% --- Custom legend for bars (as before) ---
hRed   = plot(nan, nan, 's', 'MarkerFaceColor', [0.67 0 0], 'MarkerEdgeColor', 'none');
hGreen = plot(nan, nan, 's', 'MarkerFaceColor', [0 0.67 0], 'MarkerEdgeColor', 'none');
hBlue  = plot(nan, nan, 's', 'MarkerFaceColor', [0 0 0.67], 'MarkerEdgeColor', 'none');

% Combine everything into one legend
legend([hBlue hGreen hRed hStart hStop], ...
       {'Pre-move', 'Movement', 'Post-move', 'tDCS START', 'tDCS STOP'}, ...
       'Location', 'best');
hold off


%% GraphPad Export

graphPadExport = {data.trials.t1.psd.(resultarr(1)).sai.means.(lower(freq))(:, ch)';...
data.trials.t1.psd.(resultarr(2)).sai.means.(lower(freq))(:, ch)';...
data.trials.t1.psd.(resultarr(3)).sai.means.(lower(freq))(:, ch)';...
data.trials.t1.psd.(resultarr(4)).sai.means.(lower(freq))(:, ch)';...
data.trials.t1.psd.(resultarr(5)).sai.means.(lower(freq))(:, ch)';...
data.trials.t1.psd.(resultarr(6)).sai.means.(lower(freq))(:, ch)';...
data.trials.t1.psd.(resultarr(7)).sai.means.(lower(freq))(:, ch)';...
data.trials.t1.psd.(resultarr(8)).sai.means.(lower(freq))(:, ch)';...
data.trials.t1.psd.(resultarr(9)).sai.means.(lower(freq))(:, ch)'};

writecell(graphPadExport, 'Yes');


%%
%% Channel Chooser
stim = {"Pre-Stim", "0.5 mA Anodal", "Post 0.5 mA Anodal", "1.0 mA Anodal", "Post 1.0 mA Anodal", "1.5 mA Anodal",  "Post 1.5 mA Anodal", "2.0 mA Anodal", "Post 2.0 mA Anodal", "2.0 mA Cathodal", "Post 2.0 mA Cathodal"};
freqs = {...
    'Delta',...
    'Theta',...
    'Alpha',...
    'Beta',...
    'Gamma_l',...
    'Gamma_bb'};
%%
name = {...
    "Pre-Movement",...
    "Movement",...
    "Post-Movement"};
%section = {1:9, 7:15, 13:21, 19:27, 25:33};
%%
movement = {1:3:33, 2:3:33, 3:3:33};


% clear p anovatab stats
%%
for epselect=1:length(movement)
    ep = movement{epselect};
     for j=1:length(freqs)
            figure
            freq = freqs{j};
        for ch=1:6
        chname = "c"+ch;
        
        
        subplot(3,2,ch)

    
    
        
            
            %fig = figure('Visible', 'off');
            
            
            
            
            chname = 'c' + string(ch);

            matcreator = repmat("e", 1, length(ep));
            resultarr = strings(size(length(ep)));
            for i = 1:length(ep)
                resultarr(i) = matcreator(i) + ep(i);
            end

            grping = [repmat("a", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(1)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("b", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(2)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("c", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(3)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("d", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(4)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("e", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(5)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("f", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(6)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("g", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(7)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("h", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(8)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("i", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(9)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("j", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(10)).sai.means.(lower(freq))(:, ch), 1))...
                repmat("k", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(11)).sai.means.(lower(freq))(:, ch), 1))...
            ];
            epoch_stats_gr_all_s_m = [data_pro00073545_s021.trials.t1.psd.(resultarr(1)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(2)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(3)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(4)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(5)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(6)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(7)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(8)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(9)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(10)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(11)).sai.means.(lower(freq))(:, ch)'...
            ];





            [p,anovatab,stats] = kruskalwallis(epoch_stats_gr_all_s_m, grping, 'off');
            kw_mult_output = multcompare(stats, 'ctype', 'bonferroni', 'Display', 'off');

            eval(sprintf('data_pro00073545_s021.stats.psd.test.kw.mc.kwmultoutput_c%d_e%d_%s=multcompare(stats, ''ctype'', ''bonferroni'', ''Display'', ''off'');', ch, epselect, freq));


            hold on
            bar([data_pro00073545_s021.plots.(lower(freq)).(chname).supermeans(ep)], 'FaceColor', 'flat');
            lines = kw_mult_output(find(kw_mult_output(:,6)<0.05), :);
            for i=1:size(lines, 1)
                line = lines(i, :);
                sigstar([line(1) line(2)], line(6));
            end

            %chname
            errorbar(data_pro00073545_s021.plots.(lower(freq)).(chname).supermeans(ep),data_pro00073545_s021.plots.(lower(freq)).(chname).ses(ep), '.k')
                       %ylabel([freq ' Power']);
                       %xlabel('Epoch');
                       %title(['Channel ' num2str(ch) ' '  freq ' Power '  char(name{epselect})]);
                       %xticks(1:5);
                       %xticklabels([stim{:}]);
            hold off
            %savefig(fig, ['figures/Channel ' num2str(ch) ' '  freq ' Power '  char(name{epselect}) '.fig'])
            %close(fig);
            title("channel" + ch)
            xlabel("Epoch")
            ylabel("Power")
            sgtitle(freq + " " + name{epselect});
            xticks(1:11);
            xticklabels([stim{:}]);
            
        end
        % figure
        % for ch=1:6
        %     chname2 = "c"+ch;
        %     subplot(3,2,ch);
        %     hold on
        %     scatter(ep, [data_pro00073545_s021.plots.(lower(freq)).(chname2).supermeans(ep)], "filled");
        %     mdl = fitlm(ep, [data_pro00073545_s021.plots.(lower(freq)).(chname2).supermeans(ep)]);
        %     plot(mdl);
        %     title("Channel " + ch + " Power p=" + mdl.ModelFitVsNullModel.Pvalue)
        %     xlabel("Epoch")
        %     ylabel("Power")
        % 
        %     xticks(ep)
        %     hold off
        %     sgtitle(name{epselect} + " " + freq + " Power")
        % end
        
        
    end
end

%%
%openfig("figures/Channel 6 Gamma_bb Power Post-Stimulation Pre-Movement.fig", "visible");


openfig("figures/Channel 6 Gamma_bb Power Post-Stimulation Pre-Movement.fig", "visible");

%%
table = ep; [data_pro00073545_s021.plots.(lower(freq)).(chname).supermeans(ep(2:2:11))];
%%

epselect = 2;
%%

ep = movement{epselect};
for j=1:length(freqs)
    figure
    freq = freqs{j};
    for ch=1:6
        chname = "c"+ch;
        subplot(3,2,ch)
        hold on
        scatter(ep(1:2:11), [data_pro00073545_s021.plots.(lower(freq)).(chname).supermeans(ep(1:2:11))], "filled");
        mdl = fitlm(ep(1:2:11), [data_pro00073545_s021.plots.(lower(freq)).(chname).supermeans(ep(1:2:11))]);
        plot(mdl);
        title("Channel " + ch+ "p=" + mdl.ModelFitVsNullModel.Pvalue)
        xlabel("Epoch")
        ylabel("Power")
        xticks(ep(1:2:11))
        xticklabels(["0 mA", "Post 0.5 mA", "Post 1.0 mA", "Post 1.5 mA", "Post 2.0 mA", "Post 2.0 Cathodal"]);
        hold off
    end
    sgtitle(freq)
end
%%
% Grouped Pre-Move-Post by stim state, separate KW analysis

epselect = 2;
ep = 1:33;
freq = "beta";
chname = "c4";

%bar([data_pro00073545_s021.plots.(lower(freq)).(chname).supermeans(1:33)], 'FaceColor', 'flat');


    





    %%

    % Channel Chooser
stim = {"Pre-Stim", "0.5 mA Anodal", "Post 0.5 mA Anodal", "1.0 mA Anodal", "Post 1.0 mA Anodal", "1.5 mA Anodal",  "Post 1.5 mA Anodal", "2.0 mA Anodal", "Post 2.0 mA Anodal", "2.0 mA Cathodal", "Post 2.0 mA Cathodal"};
freqs = {...
    'Delta',...
    'Theta',...
    'Alpha',...
    'Beta',...
    'Gamma_l',...
    'Gamma_bb'};
%
name = {...
    "Pre-Movement",...
    "Movement",...
    "Post-Movement"};
%section = {1:9, 7:15, 13:21, 19:27, 25:33};
%
movement = {1:3:33, 2:3:33, 3:3:33};


ep = 1:33;


for j=1:length(freqs)
    figure
    freq = freqs{j};
    for ch=1:6
 
        chname = "c"+ch;
        
        
        subplot(3,2,ch)
        
        originalArray = [data_pro00073545_s021.plots.(lower(freq)).(chname).supermeans(1:33)];
        newLength = 44;
        newArray = zeros(1, newLength); % Or use NaN if appropriate
        numberToInsert = 0;
        origIdx = 1;
        for newIdx = 1:newLength
        if mod(newIdx, 4) == 0 % If it's a fourth index (3, 6, 9, ...)
            newArray(newIdx) = numberToInsert;
        else
            newArray(newIdx) = originalArray(origIdx);
            origIdx = origIdx + 1;
        end
        end
        
        
        matcreator = repmat("e", 1, length(ep));
        resultarr = strings(size(length(ep)));
        for i = 1:length(ep)
            resultarr(i) = matcreator(i) + ep(i);
        end
        labels = ["Pre-Stimulation", "0.5 mA", "Post 0.5 mA", "1.0 mA", "Post 1.0 mA", "1.5 mA", "Post 1.5 mA", "2.0 mA", "Post 2.0 mA", "2.0 mA Cathodal", "Post 2.0 mA Cathodal"];
        for l=1:11
            grping = [repmat("a", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr((3*l)-2)).sai.means.(lower(freq))(:, ch), 1))...
            repmat("b", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr((3*l)-1)).sai.means.(lower(freq))(:, ch), 1))...
            repmat("c", 1, size(data_pro00073545_s021.trials.t1.psd.(resultarr(3*l)).sai.means.(lower(freq))(:, ch), 1))...
            ];
            epoch_stats_gr_all_s_m = [data_pro00073545_s021.trials.t1.psd.(resultarr((3*l)-2)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr((3*l)-1)).sai.means.(lower(freq))(:, ch)'...
            data_pro00073545_s021.trials.t1.psd.(resultarr(3*l)).sai.means.(lower(freq))(:, ch)'...
            ];
            
            
            
            
            
            [p,anovatab,stats] = kruskalwallis(epoch_stats_gr_all_s_m, grping, 'off');
            labels(l);
            kw_mult_output = multcompare(stats, 'ctype', 'bonferroni', 'Display', 'off');
            
            %eval(sprintf('data_pro00073545_s021.stats.psd.test.kw.mc.kwmultoutput_c%d_e%d_%s=multcompare(stats, ''ctype'', ''bonferroni'', ''Display'', ''off'');', ch, epselect, freq));
            
            
            hold on
            bar(((l*4)-3):l*4-1,[newArray(((l*4)-3):l*4-1)], 'FaceColor', 'flat');
            lines = kw_mult_output(find(kw_mult_output(:,6)<0.05), :);
        for i=1:size(lines, 1)
            line = lines(i, :);
            sigstar([4*l-(4-line(1)) 4*l-(4-line(2))], line(6));
        end
        
        %chname
        errorbar(((l*4)-3):l*4-1, data_pro00073545_s021.plots.(lower(freq)).(chname).supermeans(((l*3)-2):l*3),data_pro00073545_s021.plots.(lower(freq)).(chname).ses(((l*3)-2):l*3), '.k')
               %ylabel([freq ' Power']);
               %xlabel('Epoch');
               %title(['Channel ' num2str(ch) ' '  freq ' Power '  char(name{epselect})]);
               
               %xticklabels([stim{:}]);
        hold off
        %savefig(fig, ['figures/Channel ' num2str(ch) ' '  freq ' Power '  char(name{epselect}) '.fig'])
        %close(fig);
        title("channel" + ch)
        xlabel("Epoch")
        ylabel("Power")
        sgtitle(freq);
        xticks(2:4:44);
        xticklabels([stim{:}]);
        xlim([0 45]);
        
        end
        
    end
end

%% Spectrograms
figure
spectrogram(data_pro00073545_s021.trials.t1.sig.ecog(:,3),512,[],1024,1000);
            view(90,90);
            colormap jet;
            colorbar('delete');
            colorbar east Visible on;
            axis xy;
            set(gca, 'XDir', 'reverse');
            xlim([0 200]); 
            

%%
 figure
    
eps = [1 4 10 16 22 28];
    for i=1:6
        subplot(6,2,(2*i-1))
        hold on
        eval("plot(data_pro00073545_s021.trials.t1.sig.ecog(data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)) + "(1,1):data_pro00073545_s021.trials.t1.epochs.e" + num2str(eps(i)+2) + "(1,2),3))");
        xline(eval("data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)) + "(1,2)-data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)) + "(1,1)"), "--b");
        xline(eval("data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)+1) + "(1,1)-data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)) + "(1,1)"), "--g");
        xline(eval("data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)+1) + "(1,2)-data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)) + "(1,1)"), "--g");
        xline(eval("data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)+2) + "(1,1)-data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)) + "(1,1)"), "--r");
        xline(eval("data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)+2) + "(1,2)-data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)) + "(1,1)"));

        hold off
        subplot(6,2,(2*i));
        try eval(["spectrogram(data_pro00073545_s021.trials.t1.sig.ecog(data_pro00073545_s021.trials.t1.epochs.e"+ num2str(eps(i)) + "(1,1):data_pro00073545_s021.trials.t1.epochs.e" + num2str(eps(i)+2) + "(1,2),3),512,[],1024,1000)"]);  catch; close(gcf); continue; end
        view(90, 90);
        
        colormap jet;
        colorbar('delete');
        colorbar east Visible on;
        axis xy;
        set(gca, 'XDir', 'reverse');
        xlim([0 200]);
        
        clim([-120 -90])

    end
    
    try set(gcf,'units','normalized','outerposition',[0 0 1 1]); catch; end;
    sgtitle("Patient 21")
    %filename = [pz sz 'spectrograms.png']
    %saveas(gcf, [pz sz 'spectrograms.png']);

    %% Adjust Plots to columnar by epoch, add raw data


figure

spectrogram(data_pro00073545_s021.trials.t1.sig.ecog(data_pro00073545_s021.trials.t1.epochs.e16(1,1):data_pro00073545_s021.trials.t1.epochs.e18(1,2),3),512,[],1024,1000);
            view(90,90);
            colormap jet;
            colorbar('delete');
            colorbar east Visible on;
            axis xy;
            set(gca, 'XDir', 'reverse');
            xlim([0 200]); 
            
