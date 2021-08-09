 function startupFcn(app)
            warning off all
            clear global
            
%             global NoofChip scanMenu logo_img FluorMode...
%                 lensMag chName AFRange AFInterval refZ
            global NoofChip scanMenu logo_img FluorMode...
                lensMag chName AFRange AFInterval refZ ChipInform
            
            global_var(app)
            
            for chipNumi = 1:size(ChipInform, 2)

                grpStr = sprintf('uibuttongroup_C%d', chipNumi)

                grpWidth = app.(grpStr).Position(3);
                grpHeight = app.(grpStr).Position(4);                
                
                numVer = ChipInform(chipNumi).ChamberNum(1);
                numHor = ChipInform(chipNumi).ChamberNum(2);
                
                btnWidth = grpWidth / (numVer+2);
                btnHeight = grpHeight / (numHor+2);
                
                if strcmp(ChipInform(chipNumi).Type, 'WellPlate')

                    labelVer = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
                    labelHor = 12:-1:1;
                    labelWidth = btnWidth;
                    labelHeight = btnHeight;
                    
                    for i = 1:length(labelVer)
                            
                        labelStr = sprintf('LabelVer%d', i);
                        labelX = labelWidth * i;
                        labelY = grpHeight - labelHeight;
                        app.(labelStr).Position = [labelX, labelY, labelWidth, labelHeight];
                        app.(labelStr).Text = labelVer(i);
                            
                    end
                    
                    for i = 1:length(labelHor)
                        
                        labelStr = sprintf('LabelHor%d', i);
                        labelX = 0;
                        labelY = grpHeight - (labelHeight * (i+1));
                        app.(labelStr).Position = [labelX, labelY, labelWidth, labelHeight];
                        app.(labelStr).Text = num2str(labelHor(i));
                        
                    end

                else

                    % Invisible all labels
                    for i = 1:8
                        
                        labelStr = sprintf('LabelVer%d', i);
                        set(app.(labelStr).Visible, 'Off')                        
                            
                    end
                    
                    for i = 1:12                        
                        
                        labelStr = sprintf('LabelHor%d', i);
                        set(app.(labelStr).Visible, 'Off')
                        
                    end

                end
                
                for i = 1:numVer
                    
                    for ii = 1:numHor
                        
                        numBtn = numVer * (ii-1) + i;
                        btnStr = sprintf('togglebutton_C%d_Chamb%d', chipNumi, numBtn);
                        app.(btnStr).Text = '';
                        btnX = btnWidth * (i - 1);
                        btnY = grpHeight - (btnHeight * ii);        
                        app.(btnStr).Position = [btnX+labelWidth btnY-labelHeight btnWidth btnHeight];
                        app.(btnStr).Tag = btnStr;
                        
                    end
                    
                end
                
                axis(app.axes_C1, 'off')
                set(app.axes_C1, 'Visible', 'Off')

            end
            
            
            set(app.uibuttongroup_C1, 'Visible', 'on')
            set(app.uibuttongroup_Manual, 'Visible', 'off')
            
            set(app.edit_Range, 'Value', AFRange)
            set(app.edit_RefZ, 'Value', refZ)
            
            set(app.togglebutton_C1_Chamb1, 'Value', 1);
           
            if strcmp(FluorMode, 'PE')
            
                set(app.radiobutton_Ch2, 'FontColor', [1 1 0]);
                set(app.radiobutton_Ch2, 'Visible', 'on');
            
            elseif strcmp(FluorMode, 'FITC')
            
                set(app.radiobutton_Ch2, 'FontColor', [0 1 0]);
                set(app.radiobutton_Ch2, 'Visible', 'on');
            
            else
            
                % None
                FluorMode = 'None';
                set(app.radiobutton_Ch2, 'Visible', 'off');
            
            end
            
            nameStr = sprintf('iMeasy100 (%s / %dx / %s)', FluorMode, lensMag, chName);
            set(app.figure1, 'Name', nameStr);
            app.ImageLogo.ImageSource = logo_img;

            for i = 1:NoofChip

                btnGrpStr = sprintf('uibuttongroup_C%d', i);
                set(app.(btnGrpStr), 'Visible', 'off')
            
            end
            
            main_button_Enable(app, 'off');
            set(app.pushbutton_connect, 'Enable', 'on');
            axis(app.axes_camera, 'off');
            axis(app.axes_Canvas, 'off');
            set(app.text_Status, 'Text', 'Ready to Connect');
            
            scanMenu = 2;
            
            scrPos = get(0, 'ScreenSize');
            defFigPos = app.figure1.Position;
            
            app.figure1.Position(1) = scrPos(3) - defFigPos(3) - 10;
            app.figure1.Position(2) = scrPos(4) - defFigPos(4) - 50;            
            
            app.Fit.Gauss.Type = fittype('gauss1');
            app.Fit.Gauss.Opt = fitoptions('Method', 'NonlinearLeastSquares');
            app.Fit.Gauss.Opt.Upper = [Inf, 256, Inf];
            EncodeType = 2;
            Make_HProfile(app, EncodeType, imread('Code(Type2).png'));
            app.HProfile.Mplex.EncodeType{EncodeType}.NumCircle = EncodeType^2;
            app.HProfile.Mplex.EncodeType{EncodeType}.MinSideLth = 150;
            app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.RectEdge = 5.5/57;
            app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.SectEdge = 2.75/23;
            app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.SectCorner = 2.75/23*2;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(1) = 13;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(2) = 12;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(3) = 14;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(4) = 23;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(5) = 34;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(6) = 24;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(7) = 1;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(8) = 3;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(9) = 2;
            app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix(10) = 4;
            
            app.ScanProgDlg = uiprogressdlg(app.figure1);
            delete(app.ScanProgDlg)
            app.AFProgDlg = uiprogressdlg(app.figure1);
            delete(app.AFProgDlg)
            
            app.Log.Name = 'easySCAN_log';
            app.Log.FileDir = fullfile('C:', 'BIOROOTS', 'Maximultix', 'easySCAN', 'logs');
            app.Log.FilePath = fullfile...
                (app.Log.FileDir, strcat(datestr(now, 'yyyy-mm-dd HH-MM-SS'), '.txt'));
            
            if isfile(app.Log.Name)
            
                fileattrib(app.Log.Name, '+h');
            
            end
            
            if ~isfolder(app.Log.FileDir)
            
                mkdir(app.Log.FileDir);
            
            else
            
                LogDirList = dir(app.Log.FileDir);
                LogList = natsort({LogDirList(cell2mat({LogDirList.isdir})==0).name});
                LogListLth = length(LogList);
            
                if 99<LogListLth
            
                    for LogListNum = 1:(LogListLth-99)
            
                        delete(fullfile(app.Log.FileDir, LogList{LogListNum}));
            
                    end
            
                end
            
            end
        end