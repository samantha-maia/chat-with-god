class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final bool isPopular;
  final String currency;
  final String locale;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.isPopular = false,
    required this.currency,
    required this.locale,
  });

  double get yearlyDiscountPercentage {
    final yearlyMonthlyEquivalent = yearlyPrice / 12;
    return ((monthlyPrice - yearlyMonthlyEquivalent) / monthlyPrice) * 100;
  }

  String get formattedMonthlyPrice {
    switch (currency) {
      case 'BRL':
        return 'R\$ ${monthlyPrice.toStringAsFixed(2).replaceAll('.', ',')}';
      case 'USD':
        return '\$${monthlyPrice.toStringAsFixed(2)}';
      case 'EUR':
        return '€${monthlyPrice.toStringAsFixed(2)}';
      default:
        return '${currency} ${monthlyPrice.toStringAsFixed(2)}';
    }
  }

  String get formattedYearlyPrice {
    switch (currency) {
      case 'BRL':
        return 'R\$ ${yearlyPrice.toStringAsFixed(2).replaceAll('.', ',')}';
      case 'USD':
        return '\$${yearlyPrice.toStringAsFixed(2)}';
      case 'EUR':
        return '€${yearlyPrice.toStringAsFixed(2)}';
      default:
        return '${currency} ${yearlyPrice.toStringAsFixed(2)}';
    }
  }

  String get formattedYearlyMonthlyPrice {
    final monthlyEquivalent = yearlyPrice / 12;
    switch (currency) {
      case 'BRL':
        return 'R\$ ${monthlyEquivalent.toStringAsFixed(2).replaceAll('.', ',')}';
      case 'USD':
        return '\$${monthlyEquivalent.toStringAsFixed(2)}';
      case 'EUR':
        return '€${monthlyEquivalent.toStringAsFixed(2)}';
      default:
        return '${currency} ${monthlyEquivalent.toStringAsFixed(2)}';
    }
  }
}

class SubscriptionPlans {
  static List<SubscriptionPlan> getPlansForLocale(String locale) {
    switch (locale) {
      case 'pt_BR':
        return _brazilianPlans;
      case 'es_ES':
        return _spanishPlans;
      case 'en_US':
      default:
        return _usPlans;
    }
  }

  static const List<SubscriptionPlan> _brazilianPlans = [
    SubscriptionPlan(
      id: 'premium_monthly_br',
      name: 'Premium Mensal',
      description: 'Acesso completo por mês',
      monthlyPrice: 9.99,
      yearlyPrice: 79.90,
      currency: 'BRL',
      locale: 'pt_BR',
      features: [
        'Perguntas ilimitadas',
        'Sem anúncios',
        'Plano de leitura bíblica',
        'Favoritos ilimitados',
        'Suporte prioritário',
      ],
    ),
    SubscriptionPlan(
      id: 'premium_yearly_br',
      name: 'Premium Anual',
      description: 'Melhor valor - 33% de desconto',
      monthlyPrice: 9.99,
      yearlyPrice: 79.90,
      currency: 'BRL',
      locale: 'pt_BR',
      isPopular: true,
      features: [
        'Perguntas ilimitadas',
        'Sem anúncios',
        'Plano de leitura bíblica',
        'Favoritos ilimitados',
        'Suporte prioritário',
        '33% de desconto',
      ],
    ),
  ];

  static const List<SubscriptionPlan> _usPlans = [
    SubscriptionPlan(
      id: 'premium_monthly_us',
      name: 'Premium Monthly',
      description: 'Full access per month',
      monthlyPrice: 2.99,
      yearlyPrice: 23.99,
      currency: 'USD',
      locale: 'en_US',
      features: [
        'Unlimited questions',
        'No ads',
        'Bible reading plan',
        'Unlimited favorites',
        'Priority support',
      ],
    ),
    SubscriptionPlan(
      id: 'premium_yearly_us',
      name: 'Premium Yearly',
      description: 'Best value - 33% discount',
      monthlyPrice: 2.99,
      yearlyPrice: 23.99,
      currency: 'USD',
      locale: 'en_US',
      isPopular: true,
      features: [
        'Unlimited questions',
        'No ads',
        'Bible reading plan',
        'Unlimited favorites',
        'Priority support',
        '33% discount',
      ],
    ),
  ];

  static const List<SubscriptionPlan> _spanishPlans = [
    SubscriptionPlan(
      id: 'premium_monthly_es',
      name: 'Premium Mensual',
      description: 'Acceso completo por mes',
      monthlyPrice: 2.99,
      yearlyPrice: 23.99,
      currency: 'EUR',
      locale: 'es_ES',
      features: [
        'Preguntas ilimitadas',
        'Sin anuncios',
        'Plan de lectura bíblica',
        'Favoritos ilimitados',
        'Soporte prioritario',
      ],
    ),
    SubscriptionPlan(
      id: 'premium_yearly_es',
      name: 'Premium Anual',
      description: 'Mejor valor - 33% descuento',
      monthlyPrice: 2.99,
      yearlyPrice: 23.99,
      currency: 'EUR',
      locale: 'es_ES',
      isPopular: true,
      features: [
        'Preguntas ilimitadas',
        'Sin anuncios',
        'Plan de lectura bíblica',
        'Favoritos ilimitados',
        'Soporte prioritario',
        '33% descuento',
      ],
    ),
  ];
} 