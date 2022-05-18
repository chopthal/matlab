fig = uifigure;

informRemovePlate = uiconfirm(fig,...
                'Remove plates before exchanging the sample needle. Click OK when ready.Click Cancel to abort.',...
                'Information', 'Icon', 'Info');
            
disp(informRemovePlate)