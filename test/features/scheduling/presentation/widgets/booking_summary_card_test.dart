import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barbearia_appzin/features/scheduling/presentation/widgets/booking_summary_card.dart';

void main() {
  group('BookingSummaryCard Widget BDD', () {
    testWidgets(
      'Given the UI is rendering the summary, '
      'When all data is provided correctly, '
      'Then it should render the Gold layout and prices correctly',
      (WidgetTester tester) async {
        // Arrange
        var isConfirmed = false;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BookingSummaryCard(
                serviceName: 'Barba Premium',
                servicePrice: 'R\$ 65,00',
                barberName: 'Lucas Rocha',
                dateAndTime: 'Terça, 13 de Set às 11:00',
                onConfirm: () {
                  isConfirmed = true;
                },
                isLoading: false,
              ),
            ),
          ),
        );

        // Assert renders correctly
        expect(find.text('Resumo da Reserva'), findsOneWidget);
        expect(find.text('Barba Premium'), findsOneWidget);
        expect(find.text('R\$ 65,00'), findsNWidgets(3)); // Row value, subtotal and total value
        expect(find.text('Lucas Rocha'), findsOneWidget);
        expect(find.text('Terça, 13 de Set às 11:00'), findsOneWidget);
        expect(find.text('Confirmar Agendamento'), findsOneWidget);

        // Act - Tap the button
        await tester.tap(find.text('Confirmar Agendamento'));
        await tester.pumpAndSettle();

        // Assert action
        expect(isConfirmed, true);
      },
    );

    testWidgets(
      'Given the Bloc is currently loading, '
      'When the widget is built, '
      'Then it should render a CircularProgressIndicator instead of text',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BookingSummaryCard(
                serviceName: 'Barba Premium',
                servicePrice: 'R\$ 65,00',
                barberName: 'Lucas Rocha',
                dateAndTime: 'Terça, 13 de Set às 11:00',
                onConfirm: () {},
                isLoading: true, // <-- Loading state
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Confirmar Agendamento'), findsNothing);
      },
    );
  });
}
