import 'package:flutter/material.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

String translateMatchingAlgorithmDescription(
  BuildContext context,
  MatchingAlgorithm algorithm,
) {
  switch (algorithm) {
    case MatchingAlgorithm.number1:
      return S.of(context)!.documentContainsAnyOfTheseWords;
    case MatchingAlgorithm.number2:
      return S.of(context)!.documentContainsAllOfTheseWords;
    case MatchingAlgorithm.number3:
      return S.of(context)!.documentContainsThisString;
    case MatchingAlgorithm.number4:
      return S.of(context)!.documentMatchesThisRegularExpression;
    case MatchingAlgorithm.number5:
      return S.of(context)!.documentContainsAWordSimilarToThisWord;
    case MatchingAlgorithm.number6:
      return S.of(context)!.learnMatchingAutomatically;
    case MatchingAlgorithm.number0:
      return S.of(context)!.disableMatching;
  }
}

String translateMatchingAlgorithmName(
  BuildContext context,
  MatchingAlgorithm algorithm,
) {
  switch (algorithm) {
    case MatchingAlgorithm.number1:
      return S.of(context)!.any;
    case MatchingAlgorithm.number2:
      return S.of(context)!.all;
    case MatchingAlgorithm.number3:
      return S.of(context)!.exact;
    case MatchingAlgorithm.number4:
      return S.of(context)!.regularExpression;
    case MatchingAlgorithm.number5:
      return S.of(context)!.fuzzy;
    case MatchingAlgorithm.number6:
      return S.of(context)!.auto;
    case MatchingAlgorithm.number0:
      return S.of(context)!.none;
  }
}
