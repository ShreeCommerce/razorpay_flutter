import Flutter
import UIKit
import Razorpay
public class SwiftRazorpayPlugin: NSObject, FlutterPlugin, RazorpayPaymentCompletionProtocolWithData  {

  var razorpay: Razorpay!
  var _result: FlutterResult!

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "razorpay_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftRazorpayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    _result=result
    if(call.method.elementsEqual("RazorPayForm"))
        {
            let argue = call.arguments as? NSDictionary
            let product_name = argue!["name"] as? String
            let product_des = argue!["description"] as? String
            let product_image = argue!["image"] as? String
            let product_amount = argue!["amount"] as? String
            let prefill_email = argue!["email"] as? String
            let prefill_contact = argue!["contact"] as? String
            let product_theme = argue!["theme"] as? String
            let API_KEY = argue!["api_key"] as? String
            let order_id = argue!["order_id"] as? String
            let prefill_method = argue!["method"] as? String
            let notes = argue!["notes"] as? NSDictionary
            razorpay = Razorpay.initWithKey(API_KEY!, andDelegateWithData: self )
            showPaymentForm(name: product_name!, des:product_des!, image:product_image!, amount:product_amount!,email:prefill_email!, contact:prefill_contact!, theme:product_theme!, notes: notes, order_id: order_id!, method:prefill_method!);
        }
    }
    public func showPaymentForm(name:String,des:String,image:String,amount:String,email:String,contact:String,theme:String, notes: NSDictionary?, order_id:String, method:String)
    {
        let params: [String:Any] =
            [
                "name": name,
                "description": des,
                "image": image,
                "amount": amount,
                "order_id": order_id,
                "prefill":[
                    "contact": contact,
                    "email": email,
                    "method": method
                ],
                "theme":[
                    "color":theme
                ],
                "notes": notes ?? [:]
            ]
        razorpay.open(params)
    }
    public func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?)
    {
        var response = [String : String]()
        response["code"] = "0"
        response["message"] = str
        _result(response)
    }
    
    public func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?)
    {
    NSLog("RAZORPAY PAYMENT SUCCESS")
    let signature = response!["razorpay_signature"] as? String
    let razorpay_payment_id = response!["razorpay_payment_id"] as? String

        var response = [String : String]()
        response["message"] = razorpay_payment_id
        response["signature"] = signature
        response["code"] = "1"
        _result(response)
    }
}
