import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        self.contentViewController = flutterViewController
        
        // 隐藏标题栏和窗口边框
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.styleMask.insert(.fullSizeContentView)
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        
        // 禁止窗口调整大小
        self.styleMask.remove(.resizable)
        
        // 设置窗口尺寸（建议小组件尺寸）
        self.setContentSize(NSSize(width: 300, height: 150))
        
        // 保持窗口始终在前端
        self.level = .floating
        
        // 禁用窗口阴影
        self.hasShadow = false
        
        RegisterGeneratedPlugins(registry: flutterViewController)
        super.awakeFromNib()
    }
    
    // 允许拖动窗口任意位置
    override var canBecomeKey: Bool { return true }
    override var acceptsFirstResponder: Bool { return true }
}