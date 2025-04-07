import 'package:get/get.dart';

import '../modules/Appbar/bindings/appbar_binding.dart';
import '../modules/Appbar/views/appbar_view.dart';
import '../modules/Drawerscreen/bindings/drawerscreen_binding.dart';
import '../modules/Drawerscreen/views/drawerscreen_view.dart';
import '../modules/addDatascreen/bindings/add_datascreen_binding.dart';
import '../modules/addDatascreen/views/add_datascreen_view.dart';
import '../modules/addanimal/bindings/addanimal_binding.dart';
import '../modules/addanimal/views/addanimal_view.dart';
import '../modules/addemployee/bindings/addemployee_binding.dart';
import '../modules/addemployee/views/addemployee_view.dart';
import '../modules/addgroup/bindings/addgroup_binding.dart';
import '../modules/addgroup/views/addgroup_view.dart';
import '../modules/addmedicine/bindings/addmedicine_binding.dart';
import '../modules/addmedicine/views/addmedicine_view.dart';
import '../modules/animaldata/bindings/animaldata_binding.dart';
import '../modules/animaldata/views/animaldata_view.dart';
import '../modules/animaldetailscreen/bindings/animaldetailscreen_binding.dart';
import '../modules/animaldetailscreen/views/animaldetailscreen_view.dart';
import '../modules/deleteemployee/bindings/deleteemployee_binding.dart';
import '../modules/deleteemployee/views/deleteemployee_view.dart';
import '../modules/editanimal/bindings/editanimal_binding.dart';
import '../modules/editanimal/views/editanimal_view.dart';
import '../modules/editemploye/bindings/editemploye_binding.dart';
import '../modules/editemploye/views/editemploye_view.dart';
import '../modules/editmedicine/bindings/editmedicine_binding.dart';
import '../modules/editmedicine/views/editmedicine_view.dart';
import '../modules/groupanimaldetailscreen/bindings/groupanimaldetailscreen_binding.dart';
import '../modules/groupanimaldetailscreen/views/groupanimaldetailscreen_view.dart';
import '../modules/groupdetailscreen/bindings/groupdetailscreen_binding.dart';
import '../modules/groupdetailscreen/views/groupdetailscreen_view.dart';
import '../modules/groupingscreen/bindings/groupingscreen_binding.dart';
import '../modules/groupingscreen/views/groupingscreen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/inseminationdetailsreen/bindings/inseminationdetailsreen_binding.dart';
import '../modules/inseminationdetailsreen/views/inseminationdetailsreen_view.dart';
import '../modules/medicineManagementscreen/bindings/medicine_managementscreen_binding.dart';
import '../modules/medicineManagementscreen/views/medicine_managementscreen_view.dart';
import '../modules/medicinescreendetail/bindings/medicinescreendetail_binding.dart';
import '../modules/medicinescreendetail/views/medicinescreendetail_view.dart';
import '../modules/milkdetailscreen/bindings/milkdetailscreen_binding.dart';
import '../modules/milkdetailscreen/views/milkdetailscreen_view.dart';
import '../modules/milkinganimals/bindings/milkinganimals_binding.dart';
import '../modules/milkinganimals/views/milkinganimals_view.dart';
import '../modules/milktrackerscreen/bindings/milktrackerscreen_binding.dart';
import '../modules/milktrackerscreen/views/milktrackerscreen_view.dart';
import '../modules/pasturedetailscreen/bindings/pasturedetailscreen_binding.dart';
import '../modules/pasturedetailscreen/views/pasturedetailscreen_view.dart';
import '../modules/reports/bindings/reports_binding.dart';
import '../modules/reports/views/reports_view.dart';
import '../modules/reportspage/bindings/reportspage_binding.dart';
import '../modules/reportspage/views/reportspage_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/vaccinationdetailscreen/bindings/vaccinationdetailscreen_binding.dart';
import '../modules/vaccinationdetailscreen/views/vaccinationdetailscreen_view.dart';
import '../modules/viewanimal/bindings/viewanimal_binding.dart';
import '../modules/viewanimal/views/viewanimal_view.dart';
import '../modules/viewemploye/bindings/viewemploye_binding.dart';
import '../modules/viewemploye/views/viewemploye_view.dart';
import '../modules/viewgroupdetails/bindings/viewgroupdetails_binding.dart';
import '../modules/viewgroupdetails/views/viewgroupdetails_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.ADDEMPLOYEE,
      page: () => const AddemployeeView(),
      binding: AddemployeeBinding(),
    ),
    GetPage(
      name: _Paths.DELETEEMPLOYEE,
      page: () => const DeleteemployeeView(),
      binding: DeleteemployeeBinding(),
    ),
    GetPage(
      name: _Paths.EDITEMPLOYE,
      page: () => const EditemployeView(),
      binding: EditemployeBinding(),
    ),
    GetPage(
      name: _Paths.ADDMEDICINE,
      page: () => const AddmedicineView(),
      binding: AddmedicineBinding(),
    ),
    GetPage(
      name: _Paths.EDITMEDICINE,
      page: () => const EditmedicineView(),
      binding: EditmedicineBinding(),
    ),
    GetPage(
      name: _Paths.ADDANIMAL,
      page: () => const AddanimalView(),
      binding: AddanimalBinding(),
    ),
    GetPage(
      name: _Paths.MILKTRACKERSCREEN,
      page: () => MilktrackerscreenView(),
      binding: MilktrackerscreenBinding(),
    ),
    GetPage(
      name: _Paths.MEDICINE_MANAGEMENTSCREEN,
      page: () => const MedicineManagementscreenView(),
      binding: MedicineManagementscreenBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DATASCREEN,
      page: () => const AddDatascreenView(),
      binding: AddDatascreenBinding(),
    ),
    GetPage(
      name: _Paths.VIEWEMPLOYE,
      page: () => const ViewemployeView(),
      binding: ViewemployeBinding(),
    ),
    GetPage(
      name: _Paths.ANIMALDATA,
      page: () => const AnimaldataView(),
      binding: AnimaldataBinding(),
    ),
    GetPage(
      name: _Paths.VIEWANIMAL,
      page: () => const ViewanimalView(),
      binding: ViewanimalBinding(),
    ),
    GetPage(
      name: _Paths.DRAWERSCREEN,
      page: () => DrawerscreenView(),
      binding: DrawerscreenBinding(),
    ),
    GetPage(
      name: _Paths.APPBAR,
      page: () => const AppbarView(),
      binding: AppbarBinding(),
    ),
    GetPage(
      name: _Paths.EDITANIMAL,
      page: () => const EditanimalView(),
      binding: EditanimalBinding(),
    ),
    GetPage(
      name: _Paths.GROUPINGSCREEN,
      page: () => GroupingscreenView(),
      binding: GroupingscreenBinding(),
    ),
    GetPage(
      name: _Paths.ADDGROUP,
      page: () => AddgroupView(),
      binding: AddgroupBinding(),
    ),
    GetPage(
      name: _Paths.VIEWGROUPDETAILS,
      page: () => const ViewgroupdetailsView(),
      binding: ViewgroupdetailsBinding(),
    ),
    GetPage(
      name: _Paths.ANIMALDETAILSCREEN,
      page: () => AnimaldetailscreenView(),
      binding: AnimaldetailscreenBinding(),
    ),
    GetPage(
      name: _Paths.INSEMINATIONDETAILSREEN,
      page: () => const InseminationdetailsreenView(),
      binding: InseminationdetailsreenBinding(),
    ),
    GetPage(
      name: _Paths.VACCINATIONDETAILSCREEN,
      page: () => const VaccinationdetailscreenView(),
      binding: VaccinationdetailscreenBinding(),
    ),
    GetPage(
      name: _Paths.MEDICINESCREENDETAIL,
      page: () => const MedicinescreendetailView(),
      binding: MedicinescreendetailBinding(),
    ),
    GetPage(
      name: _Paths.MILKDETAILSCREEN,
      page: () => const MilkdetailscreenView(),
      binding: MilkdetailscreenBinding(),
    ),
    GetPage(
      name: _Paths.PASTUREDETAILSCREEN,
      page: () => const PasturedetailscreenView(),
      binding: PasturedetailscreenBinding(),
    ),
    GetPage(
      name: _Paths.MILKINGANIMALS,
      page: () => MilkinganimalsView(),
      binding: MilkinganimalsBinding(),
    ),
    GetPage(
      name: _Paths.GROUPDETAILSCREEN,
      page: () => const GroupdetailscreenView(),
      binding: GroupdetailscreenBinding(),
    ),
    GetPage(
      name: _Paths.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.REPORTSPAGE,
      page: () => const ReportspageView(),
      binding: ReportspageBinding(),
    ),
    GetPage(
      name: _Paths.GROUPANIMALDETAILSCREEN,
      page: () => const GroupanimaldetailscreenView(),
      binding: GroupanimaldetailscreenBinding(),
    ),
  ];
}
