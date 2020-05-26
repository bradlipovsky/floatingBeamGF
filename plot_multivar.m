function plot_multivar(sigma,accept,xStep,x_keep,M_frac,x0,numIt,p,paramsVaried,axisLabels,maxNumBins,L_type)

% get useful info
numParams = length(paramsVaried);
numPanelSide = numParams + 1;
 
% get max value of histogram for axis limit
m = zeros(numPanelSide,1);
for i = 1:numParams
        
    % get number of bins
    numBins = length(unique(x_keep(paramsVaried(i),:)));
    if numBins > maxNumBins
        numBins = maxNumBins;
    end
    
    h = histcounts(x_keep(paramsVaried(i),:),numBins);
    m(i) = max(h);
end
h = histcounts(M_frac,numBins);
m(end) = max(h);
lim = max(m) + max(m)/10;

% make gridded plots of all independent parameters
for i = 1:numParams
    for j = i:numParams
        
        if i ~= j
            
            % get number of bins
            numBins = length(unique(x_keep(paramsVaried(i),:)));
            if numBins > maxNumBins
                numBins = maxNumBins;
            end
    
            % get point with max density for current variable pair
            xFit = getFit(x_keep,[paramsVaried(i) paramsVaried(j)],numBins,x0);

            % make dscatter density plot of results
            figInd = sub2ind([numPanelSide,numPanelSide],j,i);
            subplot(numPanelSide,numPanelSide,figInd);           
            dscatter(x_keep(paramsVaried(j),:)',x_keep(paramsVaried(i),:)','BINS',[numBins,numBins]);
            ax = gca;
            ax.YAxisLocation = "right";
            ax.XAxisLocation = "top";
            xline(xFit(paramsVaried(j)),"r--");
            yline(xFit(paramsVaried(i)),"r--");
            xlim([min(x_keep(paramsVaried(j),:)),max(x_keep(paramsVaried(j),:))]);
            ylim([min(x_keep(paramsVaried(i),:)),max(x_keep(paramsVaried(i),:))]);
            box on;
            if figInd > length(paramsVaried)
                xticklabels(gca,{})
            else
                xlabel(axisLabels(j))
            end
            yticklabels(gca,{})
        end
        
    end

    % make histogram
    histInd = sub2ind([numPanelSide,numPanelSide],i,i);
    subplot(numPanelSide,numPanelSide,histInd);
    histogram(x_keep(paramsVaried(i),:),numBins);
    xlim([min(x_keep(paramsVaried(i),:)),max(x_keep(paramsVaried(i),:))]);
    ylim([0,lim]);
    xlabel(axisLabels(i))
end

% make column of M_frac plots
for i = 1:numParams
    
    % get number of bins
    numBins = length(unique(x_keep(paramsVaried(i),:)));
    if numBins > maxNumBins
        numBins = maxNumBins;
    end
    
    % get point with max density for current variable pair
    xFit = getFit([x_keep(i,:);M_frac],[1 2],numBins,x0);

    figInd = sub2ind([numPanelSide,numPanelSide],numPanelSide,i);
    subplot(numPanelSide,numPanelSide,figInd);           
    dscatter(M_frac',x_keep(paramsVaried(i),:)','BINS',[numBins,numBins]);
    ax = gca;
    ax.YAxisLocation = "right";
    ax.XAxisLocation = "top";            
    xline(xFit(2),"r--");
    yline(xFit(1),"r--");
    
    xlim([min(M_frac),max(M_frac)]);
    ylim([min(x_keep(paramsVaried(i),:)),max(x_keep(paramsVaried(i),:))]);
    box on;
    ylabel(axisLabels(i))                
    if i == 1
        xlabel("M_{obs}/M_0")
    else
        xticklabels(gca,{})
    end
    
end

% make histogram of M_frac
subplot(numPanelSide,numPanelSide,numPanelSide*numPanelSide);
histogram(M_frac,numBins);
xlim([min(M_frac),max(M_frac)]);
ylim([0,lim]);
xlabel("M_{obs}/M_0")

% report parameters and settings for MCMC
subplot(numPanelSide,numPanelSide,numPanelSide*numPanelSide-(numPanelSide-1))
yticklabels(gca,{})
xticklabels(gca,{})
set(gca, 'visible', 'off')
text(0,1,string("MCMC parameters" + newline + "----------------------------" + newline + ...                            
                       "h_i step: " + xStep(1) + " m    h_w step: " + xStep(2) + " m" + newline + ...
                       "X_{stat} step: " + xStep(3) + " m    t_0 step: " + xStep(4) + " s" + newline + ...
                       "Number of iterations: " + numIt + newline + "Sigma: " + sigma + newline + ...
                       "Liklihood function: " + L_type + newline + "Accepted " + ...
                       round(100*sum(accept)/length(accept)) + "% of proposals"))                   
            
% set figure size and title
set(gcf,'Position',[10 10 1000 800])
sgtitle("Result of MCMC inversion after " + numIt + " iterations" + newline)

saveas(gcf,"/home/setholinger/Documents/Projects/PIG/modeling/mcmc/run" + ...
           p + "_multivar_dscatter.png")
close(gcf)

end