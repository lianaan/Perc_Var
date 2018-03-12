function resp_types_counts = resp_types_update_all(data, right_buttons_set, left_buttons_set)
%resp_types_counts : 8 types of errors in 4 conditions: ORI, COL,
%ORI-SW, COL-SW
%8 columns* 4 rows

resp_type_counts = nan(1, length(data));
if isfield(data,'resp_buttons')  %then we can fill all 8 columns without ambiguity
    for i=1: length(data) %right
        
        if data(i).cue_index==1 %right
            if ismember( data(i).resp_buttons, right_buttons_set)
                if data(i).trial_type==1 %orientation trial
                    if ismember(data(i).resp_buttons, right_buttons_set(1:2)) %correct modality

                        resp_types_counts(i)=data(i).resp; % type 1, correct categ  
                       
                    elseif ismember(data(i).resp_buttons, right_buttons_set(3:4)) %INcorrect modality
                        if data(i).colors<0
                            if data(i).resp_buttons==right_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=3; % type 3, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(3) %more yellow %data(i).resp==1
                                resp_types_counts(i)=4; %type 4, INcorrect cat
                            end
                        elseif data(i).colors>=0
                            if data(i).resp_buttons==right_buttons_set(3) %more yellow %data(i).resp==1
                                resp_types_counts(i)=3; % type 3, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=4; %type 4, INcorrect cat
                            end
                        end
                    end
                end
                if data(i).trial_type==2 %color trial
                    if ismember(data(i).resp_buttons, right_buttons_set(3:4)) %correct modality
                        resp_types_counts(i)=data(i).resp;
                    elseif ismember(data(i).resp_buttons, right_buttons_set(1:2)) %INcorrect modality
                        if data(i).orientations<0
                            if data(i).resp_buttons==right_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=3; % type 3, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=4; %type 4, INcorrect cat
                            end
                        elseif data(i).orientations>=0
                            if data(i).resp_buttons==right_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=3; % type 3, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(1) %clockwise %data(i).resp==0
                                resp_types_counts(i)=4; %type 4, INcorrect cat
                            end
                        end
                    end
                end
            elseif ismember( data(i).resp_buttons, left_buttons_set)  %INCORRECT SPACE
                if data(i).trial_type==1 %orientation trial
                    if ismember(data(i).resp_buttons, left_buttons_set(1:2)) %correct modality
                        if data(i).orientations<0
                            if data(i).resp_buttons==left_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=5; % type 5, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(1) %clockwise%data(i).resp==1
                                resp_types_counts(i)=6; %type 6, INcorrect cat
                            end
                        elseif data(i).orientations>=0
                            if data(i).resp_buttons==left_buttons_set(1) %clockwise%data(i).resp==1
                                resp_types_counts(i)=5; % type 5, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=6; %type 6, INcorrect cat
                            end
                        end
                    elseif ismember(data(i).resp_buttons, left_buttons_set(3:4)) %INcorrect modality
                        if data(i).colors<0
                            if data(i).resp_buttons==left_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=7; % type 7, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(3) %more yellow %data(i).resp==1
                                resp_types_counts(i)=8; %type 8, INcorrect cat
                            end
                        elseif data(i).colors>=0
                            if data(i).resp_buttons==left_buttons_set(3) %more yellow %data(i).resp==1
                                resp_types_counts(i)=7; % type 7, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=8; %type 8, INcorrect cat
                            end
                        end
                    end
                end
                if data(i).trial_type==2 %color trial
                    if ismember(data(i).resp_buttons, left_buttons_set(3:4)) %correct modality
                        if data(i).colors<0
                            if data(i).resp_buttons==left_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=5; % type 5, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(3) %more yellow %data(i).resp==1
                                resp_types_counts(i)=6; %type 6, INcorrect cat
                            end
                        elseif data(i).colors>=0
                            if data(i).resp_buttons==left_buttons_set(3) %more yellow %data(i).resp==1
                                resp_types_counts(i)=5; % type 5, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=6; %type 6, INcorrect cat
                            end
                        end
                    elseif ismember(data(i).resp_buttons, left_buttons_set(1:2)) %INcorrect modality
                        if data(i).orientations<0
                            if data(i).resp_buttons==left_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=7; % type 7, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(1) %clockwise%data(i).resp==1
                                resp_types_counts(i)=8; %type 8, INcorrect cat
                            end
                        elseif data(i).orientations>=0
                            if data(i).resp_buttons==left_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=7; % type 7, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(2) %counterclockwise%data(i).resp==0
                                resp_types_counts(i)=8; %type 8, INcorrect cat
                            end
                        end
                    end
                end
                
            end
            
            
        elseif data(i).cue_index==2 %left
            if ismember( data(i).resp_buttons, left_buttons_set)
                if data(i).trial_type==1 %orientation trial
                    if ismember(data(i).resp_buttons, left_buttons_set(1:2)) %correct modality
                        resp_types_counts(i)=data(i).resp;
                    elseif ismember(data(i).resp_buttons, left_buttons_set(3:4)) %INcorrect modality
                        if data(i).colors<0
                            if data(i).resp_buttons==left_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=3; % type 3, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(3) %more yellow %data(i).resp==1
                                resp_types_counts(i)=4; %type 4, INcorrect cat
                            end
                        elseif data(i).colors>=0
                            if data(i).resp_buttons==left_buttons_set(3) %more yellow %data(i).resp==1
                                resp_types_counts(i)=3; % type 3, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=4; %type 4, INcorrect cat
                            end
                        end
                    end
                end
                if data(i).trial_type==2 %color trial
                    if ismember(data(i).resp_buttons, left_buttons_set(3:4)) %correct modality
                        resp_types_counts(i)=data(i).resp;
                    elseif ismember(data(i).resp_buttons, left_buttons_set(1:2)) %INcorrect modality
                        if data(i).orientations<0
                            if data(i).resp_buttons==left_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=3; % type 3, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=4; %type 4, INcorrect cat
                            end
                        elseif data(i).orientations>=0
                            if data(i).resp_buttons==left_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=3; % type 3, correct categ
                            elseif data(i).resp_buttons==left_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=4; %type 4, INcorrect cat
                            end
                        end
                    end
                end
            elseif ismember( data(i).resp_buttons, right_buttons_set)  %INCORRECT SPACE
                if data(i).trial_type==1 %orientation trial
                    if ismember(data(i).resp_buttons, right_buttons_set(1:2)) %correct modality
                        if data(i).orientations<0
                            if data(i).resp_buttons==right_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=5; % type 5, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=6; %type 6, INcorrect cat
                            end
                        elseif data(i).orientations>=0
                            if data(i).resp_buttons==right_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=5; % type 5, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=6; %type 6, INcorrect cat
                            end
                        end
                    elseif ismember(data(i).resp_buttons, right_buttons_set(3:4)) %INcorrect modality
                        if data(i).colors<0
                            if data(i).resp_buttons==right_buttons_set(4) %more blue %data(i).resp==0
                                resp_types_counts(i)=7; % type 7, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(3) %more yellow  %data(i).resp==1
                                resp_types_counts(i)=8; %type 8, INcorrect cat
                            end
                        elseif data(i).colors>=0
                            if data(i).resp_buttons==right_buttons_set(3) %more yellow  %data(i).resp==1
                                resp_types_counts(i)=7; % type 7, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(4) %more blue  %data(i).resp==0
                                resp_types_counts(i)=8; %type 8, INcorrect cat
                            end
                        end
                    end
                end
                if data(i).trial_type==2 %color trial
                    if ismember(data(i).resp_buttons, right_buttons_set(3:4)) %correct modality
                        if data(i).colors<0
                            if data(i).resp_buttons==right_buttons_set(4) %more blue  %data(i).resp==0
                                resp_types_counts(i)=5; % type 5, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(3) %more yellow  %data(i).resp==1
                                resp_types_counts(i)=6; %type 6, INcorrect cat
                            end
                        elseif data(i).colors>=0
                            if data(i).resp_buttons==right_buttons_set(3) %more yellow  %data(i).resp==1
                                resp_types_counts(i)=5; % type 5, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(4) %more blue  %data(i).resp==0
                                resp_types_counts(i)=6; %type 6, INcorrect cat
                            end
                        end
                    elseif ismember(data(i).resp_buttons, right_buttons_set(1:2)) %INcorrect modality
                        if data(i).orientations<0
                            if data(i).resp_buttons==right_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=7; % type 7, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=8; %type 8, INcorrect cat
                            end
                        elseif data(i).orientations>=0
                            if data(i).resp_buttons==right_buttons_set(1) %clockwise %data(i).resp==1
                                resp_types_counts(i)=7; % type 7, correct categ
                            elseif data(i).resp_buttons==right_buttons_set(2) %counterclockwise %data(i).resp==0
                                resp_types_counts(i)=8; %type 8, INcorrect cat
                            end
                        end
                    end
                end
            end
        end
    end
    %elseif resp_buttons is not a field
    %for some, we have other fields---so we know (3)+(4) and
    %(5)+(6)
    
elseif isfield(data,'resp_opp_mod') & isfield(data,'resp_opp_space')
    
    
    for i=1: length(data) %right

        if isnan(data(i).resp_opp_space) %CORRECT SPACE
            if data(i).trial_type==1 %orientation trial
                if isnan(data(i).resp_opp_mod) %correct modality
                    resp_types_counts(i)=data(i).resp;
                elseif data(i).resp_opp_mod==1 %INcorrect modality
                    
                    resp_types_counts(i)=nan;
                    
                end
            end
            if data(i).trial_type==2 %color trial
                if isnan(data(i).resp_opp_mod) %correct modality
                    resp_types_counts(i)=data(i).resp;
                elseif data(i).resp_opp_mod==1 %INcorrect modality
                    
                    resp_types_counts(i)=nan;
                    
                end
            end
        elseif data(i).resp_opp_space==1 %INCORRECT SPACE
            if isnan(data(i).resp_opp_mod) %correct modality
                resp_types_counts(i)=nan;
                
            elseif data(i).resp_opp_mod==1 %INcorrect modality
                
                resp_types_counts(i)=nan;
                
            end
        end
    end
    
    
elseif isfield(data, 'resp_opp_mod')
    %counter=0;
    for i=1:length(data)
        
        if data(i).trial_type==1 %orientation trial
            if isnan(data(i).resp_opp_mod) %correct modality
                resp_types_counts(i)=data(i).resp;
            elseif data(i).resp_opp_mod==1 %INcorrect modality
                
                resp_types_counts(i)=nan;
                
            end
        end
        if data(i).trial_type==2 %color trial
            if isnan(data(i).resp_opp_mod) %correct modality
                resp_types_counts(i)=data(i).resp;
            elseif data(i).resp_opp_mod==1 %INcorrect modality, %0.25 each
                resp_types_counts(i)=nan;
                
            end
            
        end
    end
else %if none of these fields exist
    
    for i=1:length(data)

        if data(i).trial_type==1 %orientation trial
            %if isnan(data(i).resp_opp_mod) %correct modality
            resp_types_counts(i)=data(i).resp;
        elseif data(i).trial_type==2 %color trial
            
            resp_types_counts(i)=data(i).resp;
        end
    end
    
end
end



