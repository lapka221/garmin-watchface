// Импортируем нужные библиотеки
using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Time;
using Toybox.ActivityMonitor;
using Toybox.HeartRate;

class MyWatchFace extends Ui.WatchFace {

    var lastBatteryLevel;
    var lastDate;
    var lastSteps;
    var lastHeartRate;

    function initialize() {
        WatchUi.WatchFace.initialize();
        lastBatteryLevel = System.getDeviceSettings().batteryCharge;
        lastDate = Time.now().format("%Y-%m-%d");
    }

    function onUpdate(dc as Dc) {
        // Очищаем экран
        dc.clear();

        // Получаем текущее время
        var time = Time.now();
        var timeStr = time.format("%H:%M"); // без секунд для снижения нагрузки

        // Отображение данных на экране
        dc.drawText(20, 30, Gfx.FONT_XLARGE, timeStr);  // время

        // Дата обновляется раз в день, когда меняется `lastDate`
        var currentDate = time.format("%Y-%m-%d");
        if (currentDate != lastDate) {
            lastDate = currentDate;
        }
        dc.drawText(20, 60, Gfx.FONT_MEDIUM, "Date: " + lastDate);  // дата

        // Обновляем шаги только когда они меняются
        var steps = ActivityMonitor.getActivityInfo().steps;
        if (steps != lastSteps) {
            lastSteps = steps;
        }
        dc.drawText(20, 90, Gfx.FONT_MEDIUM, "Steps: " + lastSteps);   // шаги

        // Сердцебиение обновляется только при активности экрана
        var heartRate = HeartRate.getHeartRate();
        if (heartRate != lastHeartRate) {
            lastHeartRate = heartRate;
        }
        dc.drawText(20, 120, Gfx.FONT_MEDIUM, "HR: " + lastHeartRate); // сердцебиение

        // Обновляем заряд батареи только если он изменился
        var battery = System.getDeviceSettings().batteryCharge;
        if (battery != lastBatteryLevel) {
            lastBatteryLevel = battery;
        }
        dc.drawText(20, 150, Gfx.FONT_MEDIUM, "Battery: " + lastBatteryLevel + "%"); // заряд батареи
    }

    function onShow() {
        requestUpdate(); // Обновляем, когда экран активен
    }

    function onHide() {
        cancelUpdate(); // Отключаем обновления, когда экран неактивен
    }

    function onTimerTick() {
        // Обновляем каждую минуту в фоновом режиме для минимизации расхода
        requestUpdate(60000); 
    }
}
