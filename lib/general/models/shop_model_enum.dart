enum ShopStatusEnum { pending, approved, rejected }

ShopStatusEnum stringToEnum(String status) {
  switch (status) {
    case 'pending':
      return ShopStatusEnum.pending;
    case 'approved':
      return ShopStatusEnum.approved;
    case 'rejected':
      return ShopStatusEnum.rejected;
    default:
      throw ArgumentError('Invalid status: $status');
  }
}
