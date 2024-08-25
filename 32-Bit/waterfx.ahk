#Requires AutoHotkey v2.0.12 32-Bit
#DllLoad WaterFX.dll

logo := LoadPicture('..\logo.bmp')

wfx1 := WaterFx(logo)
wfx2 := WaterFx(logo)

ui := Gui(, 'WaterFx 32-Bit')
ui.OnEvent('Escape', (*) => ExitApp())
ui.OnEvent('Close', (*) => ExitApp())
ui.Show(Format('w{} h{}', wfx1.Width, wfx1.Height + 10 + wfx2.Height))

wfx1.Start(ui.Hwnd, 0, 0)
wfx1.SetBlob(2, 30, 3, 300, 4, 500)

wfx2.Start(ui.Hwnd, 0, wfx1.Height + 10)
wfx2.SetBlob(2, 30, 3, 300, 4, 500)

class WaterFx {
    __New(bitmap) {
        this.id := DllCall('waterfx\create', 'Ptr', bitmap, 'Ptr')
    }

    __Delete() {
        DllCall('waterfx\destroy', 'Ptr', this.id)
    }

    SetDensity(density := 4) {
        DllCall('waterfx\set_density', 'Ptr', this.id, 'Int', density)
    }

    SetRenderingDelay(delay := 25) {
        DllCall('waterfx\set_delay', 'Ptr', this.id, 'Int', delay)
    }

    Clear() {
        DllCall('waterfx\clear', 'Ptr', this.id)
    }

    Render(hWnd, x := 0, y := 0) {
        DllCall('waterfx\render', 'Ptr', this.id, 'Ptr', hWnd, 'Int', x, 'Int', y)
    }

    Blob(x, y, radius := 2, height := 30) {
        DllCall('waterfx\blob', 'Ptr', this.id, 'Int', x, 'Int', y, 'Int', radius, 'Int', height)
    }

    SetBlob(radius, height, r2, h2, r3, h3) {
        DllCall('waterfx\wm_mousemove', 'Ptr', this.id, 'Int', radius, 'Int', height)
        DllCall('waterfx\wm_lbuttondown', 'Ptr', this.id, 'Int', r2, 'Int', h2)
        DllCall('waterfx\wm_lbuttonup', 'Ptr', this.id, 'Int', r3, 'Int', h3)
    }

    Start(hWnd, x := 0, y := 0, w := 0, h := 0) {
        DllCall('waterfx\set_hwnd', 'Ptr', this.id, 'Ptr', hWnd)
        DllCall('waterfx\set_pos', 'Ptr', this.id, 'Int', x, 'Int', y)
        DllCall('waterfx\resize', 'Ptr', this.id, 'Int', w, 'Int', h)
        DllCall('waterfx\start', 'Ptr', this.id)
    }

    Stop() {
        DllCall('waterfx\stop', 'Ptr', this.id)
    }

    Width => DllCall('waterfx\width', 'Ptr', this.id)
    Height => DllCall('waterfx\height', 'Ptr', this.id)
}
