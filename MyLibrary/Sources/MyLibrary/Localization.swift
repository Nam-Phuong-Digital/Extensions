// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public extension String {
    static let bhtmb:String = NSLocalizedString("Bán hàng trên máy bay", bundle: .module, comment: "")
    
    static let transferInformation:String = NSLocalizedString("Thông tin bàn giao", bundle: .module, comment: "Tiêu đề màn hình bàn giao")
    static let departureDate:String = NSLocalizedString("Ngày khởi hành", bundle: .module, comment: "")
    static let flightNumber:String = NSLocalizedString("Mã số chuyến bay", bundle: .module, comment: "")
    static let flightRoute:String = NSLocalizedString("Hành trình", bundle: .module, comment: "")
    static let transferTime:String = NSLocalizedString("Thời gian giao", bundle: .module, comment: "")
    static let transferor:String = NSLocalizedString("Người bàn giao", bundle: .module, comment: "")
    static let confirmationTime:String = NSLocalizedString("Thời gian xác nhận", bundle: .module, comment: "")
    static let recipient:String = NSLocalizedString("Người nhận", bundle: .module, comment: "")
    static let sN:String = NSLocalizedString("STT", bundle: .module, comment: "viết tắt: số thứ tự/ serial number")
    static let productName:String = NSLocalizedString("Tên sản phẩm", bundle: .module, comment: "")
    static let uM:String = NSLocalizedString("ĐVT", bundle: .module, comment: "viết tắt của đơn vị tính/ Unit of Measurement")
    static let supplier:String = NSLocalizedString("Nhà cung cấp", bundle: .module, comment: "")
    static let price:String = NSLocalizedString("Giá tiền", bundle: .module, comment: "")
    static let endPrice:String = NSLocalizedString("Thành tiền", bundle: .module, comment: "")
    static let quantityTransfer:String = NSLocalizedString("Số lượng bàn giao", bundle: .module, comment: "")
    static let confirmedQuantity:String = NSLocalizedString("Số lượng xác nhận", bundle: .module, comment: "")
    static let product:String = NSLocalizedString("Sản phẩm", bundle: .module, comment: "")
    static let statistics:String = NSLocalizedString("Thống kê", bundle: .module, comment: "")
    static let transfer:String = NSLocalizedString("Bàn giao", bundle: .module, comment: "")
    static let confirm:String = NSLocalizedString("Xác nhận", bundle: .module, comment: "")
    
    static let productCategory:String = NSLocalizedString("Danh mục sản phẩm", bundle: .module, comment: "")
    static let transferBHTMB:String = NSLocalizedString("Bàn giao", bundle: .module, comment: "")
    static let statisticsReport:String = NSLocalizedString("Thống kê hàng đã bán", bundle: .module, comment: "")
    static let scanQrCodeHere:String = NSLocalizedString("Quét mã thanh toán tại đây", bundle: .module, comment: "")
    static let totalMoney:String = NSLocalizedString("Tổng tiền", bundle: .module, comment: "")
    static let attachPhotos:String = NSLocalizedString("Đính kèm ảnh minh chứng", bundle: .module, comment: "")
    static let save:String = NSLocalizedString("Lưu", bundle: .module, comment: "")
    static let all:String = NSLocalizedString("Tất cả", bundle: .module, comment: "")
 
    static let statisticSoldProduct:String = NSLocalizedString("Thống kê hàng đã bán", bundle: .module, comment: "")
    static let quantitySold:String = NSLocalizedString("Số lượng đã bán", bundle: .module, comment: "")
    static let quantityRemain:String = NSLocalizedString("Số lượng còn lại", bundle: .module, comment: "")
    
    static let quantity:String = NSLocalizedString("Số lượng", bundle: .module, comment: "")
    static let cancel:String = NSLocalizedString("Hủy", bundle: .module, comment: "")
    
    static let buyProduct:String = NSLocalizedString("Mua hàng", bundle: .module, comment: "")
    static let outOfStore:String = NSLocalizedString("Sản phẩm đã bán hết", bundle: .module, comment: "Sản phẩm đã hết số lượng")
    static let remain:String = NSLocalizedString("Còn lại", bundle: .module, comment: "Sản phẩm còn lại khi đẫ lấy tổng trừ đi tổng orders")
    static let uploadPhoto:String = NSLocalizedString("Tải hình", bundle: .module, comment: "")
    static let noData: String = NSLocalizedString("Không có dữ liệu", bundle: .module, comment: "")
    static let close: String = NSLocalizedString("Đóng", bundle: .module, comment: "")
    static let status: String = NSLocalizedString("Trạng thái", bundle: .module, comment: "")
    static let promptUserAction: String = NSLocalizedString("Bạn có chắc không?", bundle: .module, comment: "")
    static let outOfStock: String = NSLocalizedString("Hết hàng", bundle: .module, comment: "")
    static let uploadPhotosSucess = NSLocalizedString("Tải ảnh lên thành công", bundle: .module, comment: "")
    static let statisticsNotSynced = NSLocalizedString("Thống kê chưa được đồng bộ với máy chủ", bundle: .module, comment: "")
    static let syncNow = NSLocalizedString("Đồng bộ ngay", bundle: .module, comment: "")
    
    static let promptUserNoteConfirmBHTMb =  NSLocalizedString("Số lượng xác nhận khác với số lượng ban đầu. Bạn có muốn ghi chú gì thêm không?", bundle: .module, comment: "")
    static let note =  NSLocalizedString("Ghi chú", bundle: .module, comment: "")
    
    static let orders =  NSLocalizedString("Orders", bundle: .module, comment: "")
    static let serve =  NSLocalizedString("Serve", bundle: .module, comment: "")
    static let promptReloadMenuHaveOrders =  NSLocalizedString("There is an existing booking for this flight. All data related to the booking will can be deleted when you refresh the menu. Do you wish to proceed?", bundle: .module, comment: "Đang tồn tại đơn đặt hàng cho chuyến bay này. Mọi dữ liệu về đơn hàng sẽ bị xoá khi bạn tải lại thực đơn. Bạn có muốn thực hiện tiếp")
    static let promptAskReloadMenu =  NSLocalizedString("Do you want to refresh Menu?", bundle: .module, comment: "")   
    static let addNote =  NSLocalizedString("Add note", bundle: .module, comment: "")
    
    static let productInbound =  NSLocalizedString("Products inbound", bundle: .module, comment: "")
    
    static let bhtmbList =  NSLocalizedString("Danh sách phiếu", bundle: .module, comment: "")
    static let createNewBHTMB =  NSLocalizedString("Tạo phiếu", bundle: .module, comment: "")
}

