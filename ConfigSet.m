function ConfigSet(app)

DeltaBrightness = (app.BrightnessSlider.Value - app.Brightness) * 2^8; % 16 -> 8 bit
DeltaContrast = (app.ContrstSlider.Value / app.Contrast) * 2^8; % 16 -> 8 bit

app.ProcessedImg = app.CropImg * DeltaContrast + DeltaBrightness;

app.Brightness = app.BrightnessSlider.Value;
app.Contrast = app.ContrastSlider.Value;