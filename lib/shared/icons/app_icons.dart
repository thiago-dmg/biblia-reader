import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Lucide na barra: **300** inativo / **500** ativo — leitura nítida sem peso “genérico”.
abstract final class AppLucideNav {
  static IconData home(bool on) => on ? LucideIcons.house500 : LucideIcons.house300;

  static IconData bible(bool on) =>
      on ? LucideIcons.bookOpen500 : LucideIcons.bookOpen300;

  static IconData plans(bool on) =>
      on ? LucideIcons.signpost500 : LucideIcons.signpost300;

  static IconData community(bool on) =>
      on ? LucideIcons.messagesSquare500 : LucideIcons.messagesSquare300;

  static IconData profile(bool on) =>
      on ? LucideIcons.userRound500 : LucideIcons.userRound300;

  /// Sala de oração — ícone de mãos (substitui coração no estilo Divine).
  static IconData prayer(bool on) =>
      on ? LucideIcons.handHeart500 : LucideIcons.handHeart300;

  /// Barra inferior — Oração (coração), como no layout de referência.
  static IconData prayerHeart(bool on) =>
      on ? LucideIcons.heart500 : LucideIcons.heart300;

  static IconData reading(bool on) =>
      on ? LucideIcons.calendarDays500 : LucideIcons.calendarDays300;

  static IconData studiesNav(bool on) =>
      on ? LucideIcons.bookMarked500 : LucideIcons.bookMarked300;

  static IconData sosNav(bool on) =>
      on ? LucideIcons.shield500 : LucideIcons.shield300;
}

abstract final class AppLucideUi {
  static const IconData signpost = LucideIcons.signpost300;

  static const IconData bell = LucideIcons.bell300;
  static const IconData plus = LucideIcons.plus300;
  static const IconData check = LucideIcons.check300;
  static const IconData chevronRight = LucideIcons.chevronRight300;
  static const IconData penLine = LucideIcons.penLine300;
  static const IconData heart = LucideIcons.heart300;
  static const IconData messageCircle = LucideIcons.messageCircle300;
  static const IconData bookmark = LucideIcons.bookmark300;
  static const IconData settings = LucideIcons.settings300;
  static const IconData logOut = LucideIcons.logOut300;
  static const IconData user = LucideIcons.user300;
  static const IconData bookMarked = LucideIcons.bookMarked300;
  static const IconData bookOpen = LucideIcons.bookOpen300;
  static const IconData flag = LucideIcons.flag300;
  static const IconData headphones = LucideIcons.headphones300;
  static const IconData messagesSquare = LucideIcons.messagesSquare300;
}
