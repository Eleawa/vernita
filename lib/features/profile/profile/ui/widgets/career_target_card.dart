import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:vernita/core/theme/app_text_styles.dart';
import 'package:vernita/features/home/logic/cv_upload_cubit.dart';
import 'package:vernita/features/home/logic/cv_upload_state.dart';
import '../../../widgets/info_tile.dart';
import '../../../widgets/section_card.dart';
import '../../../widgets/status_chip.dart';
import '../../data/models/user_model.dart';
import '../../logic/profile_field.dart';
import 'editable_info_tile.dart';

class CareerTargetCard extends StatelessWidget {
  const CareerTargetCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Career Target',
      children: [
        EditableInfoTile(
          icon: Icons.business_center_outlined,
          field: ProfileField.careerTarget,
          user: user,
        ),
        const _CvTile(),
      ],
    );
  }
}

/// The CV isn't part of /users/me (it has its own /resumes endpoints),
/// so for now we show the CV picked on Home. TODO: connect with /resumes.
class _CvTile extends StatelessWidget {
  const _CvTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CvUploadCubit, CvUploadState>(
      builder: (context, state) {
        final cv = state is HomeCvUploaded ? state.cv : null;

        return InfoTile(
          icon: Icons.description_outlined,
          label: 'Uploaded CV / Resume',
          value: cv?.name ?? 'No CV uploaded yet',
          valueWidget: cv == null
              ? null
              : Row(
                  children: [
                    Flexible(
                      child: Text(
                        cv.name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font12GreyPoppins400W,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    const StatusChip('Parsed by AI'),
                  ],
                ),
        );
      },
    );
  }
}
