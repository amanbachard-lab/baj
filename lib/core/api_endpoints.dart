class ApiEndpoints {
  static const authenticate = '/api/authenticate';
  static const register = '/api/register';
  static const account = '/api/account';
  static const categories = '/api/service-categories';
  static const providers = '/api/providers';
  static String provider(String id) => '/api/providers/$id';
  static String reviews(String id) => '/api/providers/$id/reviews';
  static const favorites = '/api/favorites';
  static String favorite(String providerId) => '/api/favorites/$providerId';
  static const quotes = '/api/quotes';
  static const myQuotes = '/api/quotes/mine';
  static const appointments = '/api/appointments';
  static const myAppointments = '/api/appointments/mine';
  static const terms = '/api/legal/terms';
}
