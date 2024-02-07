//
//  CalendarPopoverController.swift
//  Cabinbook
//
//  Created by Dai Pham on 04/02/2024.
//  Copyright © 2024 Nam Phuong Digital. All rights reserved.
//

import UIKit

public extension UIViewController {
    func presentCalendarComponent(
        currentDate:Date = Date(),
        sourceView:Any?,
        rangeMonths:RangeMonth = DefaultRangeMonth(),
        _ result: @escaping ((Date?) -> Void)
    ) {
        let vc = CalendarPopoverController(
            currentDate: currentDate,
            sourceView:sourceView,
            rangeMonths: rangeMonths,
            result
        )
        self.present(vc, animated: true)
    }
}
fileprivate let is_smallWidth = UIScreen.main.bounds.size.width <= 320
fileprivate let is_iphone = UIDevice.current.userInterfaceIdiom != .pad
public class CalendarPopoverController: UIViewController {

    @IBOutlet weak var calendar: CalendarComponentView!
    
    private var result: ((Date?) -> Void)
    private let rangeMonths:RangeMonth
    private(set) var currentDate:Date
    public init(
        currentDate:Date,
        sourceView:Any?,
        rangeMonths:RangeMonth,
        _ result: @escaping ((Date?) -> Void)
    ) {
        self.currentDate = currentDate
        self.result = result
        self.rangeMonths = rangeMonths
        super.init(nibName: "CalendarPopoverController", bundle: .module)
        modalPresentationStyle = .popover
        if let pop = self.popoverPresentationController {
//            pop.popoverBackgroundViewClass = PopoverBackgroundView.self
            pop.delegate = self
            if let sourceView = sourceView as? UIView {
                pop.sourceView = sourceView
            } else if let sourceView = sourceView as? UIBarButtonItem {
                if #available(iOS 16, *) {
                    pop.sourceItem = sourceView
                } else {
                    pop.barButtonItem = sourceView
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if #available(iOS 14, *) {
            AppLogger.shared.loggerApp.log("\("\(NSStringFromClass(type(of: self))) \(#function)")")
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.onChangeDate = {[weak self] in
            self?.result($0)
            self?.dismiss(animated: true)
        }
        updateSize()
    }
    
    @available (iOS 13,*)
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        calendar.setCurrentDay(date: currentDate)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateSize()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #unavailable (iOS 13) {
            calendar.setCurrentDay(date: currentDate)
        }
        
        updateSize()
    }
    
    
    private func updateSize() {
        let width:CGFloat =
        if is_smallWidth {
            320
        } else {
            350
        }
        self.preferredContentSize = CGSizeMake(
            width,
            self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        )
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.result(nil)
    }
}

extension CalendarPopoverController:CalendarComponentViewDelegate {
    public func CalendarComponentView_rangeMonths() -> RangeMonth? {
        return rangeMonths
    }
}

extension CalendarPopoverController: UIPopoverPresentationControllerDelegate {
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        true
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return .none
        }
}

class PopoverBackgroundView: UIPopoverBackgroundView {
    
    private var offset = CGFloat(0)
    private var backgroundImageView: UIImageView!
    private var _arrow:UIPopoverArrowDirection = .any
    override var arrowDirection: UIPopoverArrowDirection {
        get { return _arrow }
        set { _arrow = newValue}
    }
    
    override var arrowOffset: CGFloat {
        get { return offset }
        set { offset = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override static func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    override static func arrowHeight() -> CGFloat {
        return 20
    }
    
    override class var wantsDefaultContentAppearance: Bool {
        return true
    }
}