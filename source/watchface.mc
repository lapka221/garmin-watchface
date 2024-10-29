// Импортируем нужные библиотеки
using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Time;
using Toybox.ActivityMonitor;
using Toybox.HeartRate;
using Toybox.Graphics as Gfx; // Убедитесь, что Gfx импортирован

class MyWatchFace extends Ui.WatchFace {

    var lastBatteryLevel;
    var lastDate;
    var lastSteps;
    var lastHeartRate;

    function initialize() {
        Ui.WatchFace.initialize();
        lastBatteryLevel = System.getDeviceSettings().batteryCharge;
        lastDate = Time.now().format("%Y-%m-%d");
        lastSteps = 0;  // Инициализация lastSteps
        lastHeartRate = 0;  // Инициализация lastHeartRate
    }

    function onUpdate(dc) {  // Убрано 'as DrawContext'
        try {
            dc.clear();

            var time = Time.now();
            var timeStr = time.format("%H:%M");

            dc.drawText(20, 30, Gfx.FONT_XLARGE, timeStr);

            var currentDate = time.format("%Y-%m-%d");
            if (currentDate != lastDate) {
                lastDate = currentDate;
            }
            dc.drawText(20, 60, Gfx.FONT_MEDIUM, "Date: " + lastDate);

            var steps = ActivityMonitor.getActivityInfo().steps;
            if (steps != lastSteps) {
                lastSteps = steps;
            }
            dc.drawText(20, 90, Gfx.FONT_MEDIUM, "Steps: " + lastSteps);

            var heartRate = HeartRate.getHeartRate();
            if (heartRate != lastHeartRate) {
                lastHeartRate = heartRate;
            }
            dc.drawText(20, 120, Gfx.FONT_MEDIUM, "HR: " + lastHeartRate);

            var battery = System.getDeviceSettings().batteryCharge;
            if (battery != lastBatteryLevel) {
                lastBatteryLevel = battery;
            }
            dc.drawText(20, 150, Gfx.FONT_MEDIUM, "Battery: " + lastBatteryLevel + "%");
        } catch (e) {
            System.println("Ошибка: " + e);
        }
    }

    function onShow() {
        requestUpdate(); // Запрос обновления
    }

    function onHide() {
        cancelUpdate(); // Отмена обновления
    }

    function onTimerTick() {
        requestUpdate(); // Запрос обновления при каждом тике таймера
    }
}
