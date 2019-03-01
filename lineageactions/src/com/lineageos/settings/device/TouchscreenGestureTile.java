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
import android.service.quicksettings.Tile;

import com.lineageos.settings.device.TouchscreenGesturePreferenceActivity;

public class TouchscreenGestureTile extends TileService {

    private Tile mTile;

    @Override
    public void onClick() {
        if (isLocked()) unlockAndRun();
        else launch();
    }

    @Override
    public void onTileAdded() {
        super.onTileAdded();
        setinactive();
    }

    @Override
    public void onStartListening() {
        super.onStartListening();
        setinactive();
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
        Intent start = new Intent(Intent.ACTION_VIEW);
        start.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        start.setClass(this, TouchscreenGesturePreferenceActivity.class);
        startActivityAndCollapse(start);
    }

    private void setinactive() {
        mTile = getQsTile();
        mTile.setState(mTile.STATE_INACTIVE);
        mTile.updateTile();
    }

}
