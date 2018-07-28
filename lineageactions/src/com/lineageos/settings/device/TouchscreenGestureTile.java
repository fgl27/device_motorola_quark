/*
 * Copyright (C) Felipe de Leon <fglfgl27@gmail.com>
 *
 * This file is part of Modification made by Felipe de Leon to this aplication.
 *
 * iSu is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * iSu is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with iSu.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
package com.lineageos.settings.device;

import android.content.Intent;
import android.service.quicksettings.TileService;

import com.lineageos.settings.device.TouchscreenGesturePreferenceActivity;

public class TouchscreenGestureTile extends TileService {

    @Override
    public void onClick() {
        if (isLocked()) unlockAndRun();
        else launch();
    }

    private void unlockAndRun() {
        unlockAndRun(new Runnable() {
            @Override
            public void run() {
                launch();
            }
        });
    }

    private void launch() {
        startActivityAndCollapse(new Intent(this, TouchscreenGesturePreferenceActivity.class));
    }

}
