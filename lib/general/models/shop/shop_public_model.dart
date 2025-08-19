import 'package:onbook_app/general/models/shop/certification_model.dart';
import 'package:onbook_app/general/models/shop/shop_model_enum.dart';

class ShopPublicModel {
  final String? shopId;
  final String? shopEmail;
  final String? shopName;
  final String? phoneNumber;
  final String? website;
  final String? imageUrl;
  final String? ownerName;
  final String? address1;
  final String? address2;
  final String? city;
  final String? province;
  final String? postcode;
  final String? country;
  final ShopStatusEnum? status;
  final List<CertificationModel>? certifications;

  ShopPublicModel({
    this.shopId,
    this.shopEmail,
    this.shopName,
    this.phoneNumber,
    this.website,
    this.imageUrl,
    this.ownerName,
    this.address1,
    this.address2,
    this.city,
    this.province,
    this.postcode,
    this.country,
    this.status,
    this.certifications,
  });

  factory ShopPublicModel.fromMap(Map<String, dynamic> map) {
    return ShopPublicModel(
      shopId: map['shopId'] as String?,
      shopEmail: map['shopEmail'] ?? map['email'] as String?,
      shopName: map['shopName'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      website: map['website'] as String?,
      imageUrl: map['imageUrl'] as String?,
      ownerName: map['ownerName'] as String?,
      address1: map['address1'] as String?,
      address2: map['address2'] as String?,
      city: map['city'] as String?,
      province: map['province'] as String?,
      postcode: map['postcode'] as String?,
      country: map['country'] as String?,
      status: map['status'] != null ? stringToEnum(map['status']) : null,
      certifications: map['certifications'] != null
          ? List<CertificationModel>.from(
              (map['certifications'] as List).map(
                (e) => CertificationModel.fromMap(e),
              ),
            )
          : null,
    );
  }
}
