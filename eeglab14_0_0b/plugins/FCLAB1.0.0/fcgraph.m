function outEEG=fcgraph(inEEG)
metric=inEEG.FC.graph_prop.metric;
disp('>> FCLAB: Computing graph theoretical parameters')
eval(['bands=fieldnames(inEEG.FC.' metric ');']);

if(inEEG.FC.graph_prop.plus_minus)
    signs={'plus','minus'};
    if(inEEG.FC.graph_prop.symmetrize)
        for i=1:length(bands)
            eval(['A=inEEG.FC.' metric '.' bands{i} '.adj_matrix;']);
            for x1=1:inEEG.nbchan-1;
                for x2=x1+1:inEEG.nbchan
                    A(x1,x2)=max(A(x1,x2),A(x2,x1));
                    A(x2,x1)=A(x1,x2);
                end;
            end;
            eval(['inEEG.FC.' metric '.' bands{i} '.sym_adj_matrix=A;']);
            clear A;
        end;
    end;
    for i=1:length(bands)
         eval(['A=inEEG.FC.' metric '.' bands{i} '.adj_matrix;']);
         Amin=A;
         Apl=A;
         Amin(Amin>0)=0;
         Amin=-Amin;
         Apl(Apl<0)=0;
         eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_plus=Apl;']);
         eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_minus=Amin;']);
         eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_plus_GP=fclab_graphproperties(inEEG.FC.'...
             metric '.' bands{i} '.adj_matrix_plus);']);
         eval(['inEEG.FC.' metric '.' bands{i} '.adj_matrix_minus_GP=fclab_graphproperties(inEEG.FC.'...
             metric '.' bands{i} '.adj_matrix_minus);']);
    
    end;
        
else
    if(inEEG.FC.graph_prop.symmetrize)
        for i=1:length(bands)
            eval(['A=inEEG.FC.' metric '.' bands{i} '.adj_matrix;']);
            for x1=1:inEEG.nbchan-1;
                for x2=x1+1:inEEG.nbchan
                    A(x1,x2)=max(A(x1,x2),A(x2,x1));
                    A(x2,x1)=A(x1,x2);
                end;
            end;
            eval(['inEEG.FC.' metric '.' bands{i} '.sym_adj_matrix=A;']);
            eval(['inEEG.FC.' metric '.' bands{i} '.sym_adj_matrix_GP=fclab_graphproperties(inEEG.FC.'...
                metric '.' bands{i} '.sym_adj_matrix);']);
    
            clear A;
        end;
    end;

    if((inEEG.FC.graph_prop.threshold==1) & isempty(inEEG.FC.graph_prop.absthr) & isempty(inEEG.FC.graph_prop.propthr))
        error('No Value for Threshold')
        return;
    else
        if(inEEG.FC.graph_prop.symmetrize==0)
            if(~isempty(inEEG.FC.graph_prop.absthr))
                if (inEEG.FC.graph_prop.binarize==0)
                    for i=1:length(bands)
                        eval(['inEEG.FC.' metric '.' bands{i} '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '=threshold_absolute(inEEG.FC.' metric '.' bands{i}...
                            '.adj_matrix,' inEEG.FC.graph_prop.absthr ');']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_GP=fclab_graphproperties(inEEG.FC.' metric '.' bands{i} '.absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') ');']);
    
                    end;
                else
                    for i=1:length(bands)
                        eval(['A=threshold_absolute(inEEG.FC.' metric '.' bands{i} ...
                            '.adj_matrix,' inEEG.FC.graph_prop.absthr ');']);
                        A(A~=0)=1;
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') '=A;']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_GP=fclab_graphproperties(inEEG.FC.' metric '.' bands{i} '.bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') ');']);
                        
                        clear A;

                    end;
                end;
            end;

            if(~isempty(inEEG.FC.graph_prop.propthr))
                if (inEEG.FC.graph_prop.binarize==0)
                    for i=1:length(bands)
                        eval(['inEEG.FC.' metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr ...
                            '=threshold_proportional(inEEG.FC.' metric '.'...
                            bands{i} '.adj_matrix,' ...
                            num2str(str2num(inEEG.FC.graph_prop.propthr)/100) ');']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr '_GP=fclab_graphproperties(inEEG.FC.'...
                            metric '.' bands{i} '.propthr_'...
                            inEEG.FC.graph_prop.propthr ');']);
                    end;
                else
                   for i=1:length(bands)
                        eval(['A=threshold_proportional(inEEG.FC.' metric '.' bands{i} ...
                            '.adj_matrix,' num2str(str2num(inEEG.FC.graph_prop.propthr)/100) ');']);
                        A(A~=0)=1;
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_propthr_'...
                            inEEG.FC.graph_prop.propthr '=A;']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.bin_propthr_'...
                            inEEG.FC.graph_prop.propthr '_GP=fclab_graphproperties(A);']);
                        
                        clear A;
                    end;
                end;     
            end;
        else
            if(~isempty(inEEG.FC.graph_prop.absthr))
                if (inEEG.FC.graph_prop.binarize==0)
                    for i=1:length(bands)
                        eval(['inEEG.FC.' metric '.' bands{i} '.sym_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '=threshold_absolute(inEEG.FC.' metric '.' bands{i}...
                            '.sym_adj_matrix,' inEEG.FC.graph_prop.absthr ');']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.sym_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_GP=fclab_graphproperties(inEEG.FC.' metric...
                            '.' bands{i} '.sym_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_') ');']);
                        
                    end;
                else
                    for i=1:length(bands)
                        eval(['A=threshold_absolute(inEEG.FC.' metric '.' bands{i} ...
                            '.sym_adj_matrix,' inEEG.FC.graph_prop.absthr ');']);
                        A(A~=0)=1;
                        eval(['inEEG.FC.' metric '.' bands{i} '.sym_bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '=A;']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.sym_bin_absthr_'...
                            strrep(inEEG.FC.graph_prop.absthr,'.','_')...
                            '_GP=fclab_graphproperties(A);']);
                        clear A;

                    end;
                end;
            end;

            if(~isempty(inEEG.FC.graph_prop.propthr))
                if (inEEG.FC.graph_prop.binarize==0)
                    for i=1:length(bands)
                        eval(['inEEG.FC.' metric '.' bands{i} '.sym_propthr_'...
                            inEEG.FC.graph_prop.propthr ...
                            '=threshold_proportional(inEEG.FC.' metric '.' ...
                            bands{i} '.sym_adj_matrix,'...
                            num2str(str2num(inEEG.FC.graph_prop.propthr)/100) ');']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.sym_propthr_'...
                            inEEG.FC.graph_prop.propthr ...
                            '_GP=fclab_graphproperties(inEEG.FC.'...
                            metric '.' bands{i} '.sym_propthr_'...
                            inEEG.FC.graph_prop.propthr ');']);
                    end;
                else
                   for i=1:length(bands)
                        eval(['A=threshold_proportional(inEEG.FC.' metric '.' bands{i} ...
                            '.adj_matrix,' num2str(str2num(inEEG.FC.graph_prop.propthr)/100) ');']);
                        A(A~=0)=1;
                        eval(['inEEG.FC.' metric '.' bands{i} '.sym_bin_propthr_'...
                            inEEG.FC.graph_prop.propthr '=A;']);
                        
                        eval(['inEEG.FC.' metric '.' bands{i} '.sym_bin_propthr_'...
                            inEEG.FC.graph_prop.propthr...
                            '_GP=fclab_graphproperties(A);']);
                        clear A;
                    end;
                end;     
            end;
        end;
    end;
end


outEEG=inEEG;
