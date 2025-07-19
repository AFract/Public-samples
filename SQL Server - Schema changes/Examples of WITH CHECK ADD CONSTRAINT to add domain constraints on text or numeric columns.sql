ALTER TABLE [dbo].[WeatherForecast] DROP CONSTRAINT IF EXISTS [CK_WeatherForecast_Summary];
ALTER TABLE [dbo].[WeatherForecast] DROP CONSTRAINT IF EXISTS CK_WeatherForecast_Summary_IsAlpha;
ALTER TABLE [dbo].[WeatherForecast] DROP CONSTRAINT IF EXISTS CK_WeatherForecast_Temperature;
ALTER TABLE [dbo].[WeatherForecast] DROP CONSTRAINT IF EXISTS CK_WeatherForecast_SummaryAndTemp;
ALTER TABLE [dbo].[WeatherForecast] DROP CONSTRAINT IF EXISTS CK_WeatherForecast_Date

ALTER TABLE [dbo].[WeatherForecast]
WITH CHECK ADD CONSTRAINT [CK_WeatherForecast_Summary] CHECK  
([Summary] = 'Balmy'
OR [summary]='Bracing'
OR [summary]='Chilly'
OR [summary]='Cool'
OR [summary]='Freezing'
OR [summary]='Hot'
OR [summary]='Mild'
OR [summary]='Scorching'
OR [summary]='Sweltering'
OR [summary]='Warm');

ALTER TABLE WeatherForecast ADD CONSTRAINT CK_WeatherForecast_Summary_IsAlpha CHECK 
(len(summary) > 2);

ALTER TABLE [dbo].[WeatherForecast] 
WITH CHECK ADD CONSTRAINT CK_WeatherForecast_Temperature CHECK 
(TemperatureC >= -50 AND TemperatureC <= 80);

ALTER TABLE [dbo].[WeatherForecast] 
WITH CHECK ADD CONSTRAINT CK_WeatherForecast_SummaryAndTemp CHECK 
((TemperatureC < 0 AND [summary]='Freezing') OR ([summary] <>'Freezing'));

ALTER TABLE WeatherForecast ADD CONSTRAINT CK_WeatherForecast_Date CHECK 
([Date] < getdate() and Date > '01/01/2025');