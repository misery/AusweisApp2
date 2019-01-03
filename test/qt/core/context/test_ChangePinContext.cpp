/*!
 * \brief Test for \ref ChangePinContext.
 *
 * \copyright Copyright (c) 2018 Governikus GmbH & Co. KG, Germany
 */

#include "context/ChangePinContext.h"

#include <QtTest>

#include "TestFileHelper.h"

using namespace governikus;

class test_ChangePinContext
	: public QObject
{
	Q_OBJECT

	private Q_SLOTS:
		void test_NewPin()
		{
			ChangePinContext context;
			const QString pin1 = QStringLiteral("456789");
			const QString pin2 = QStringLiteral("111111");
			const QString pin3 = QStringLiteral("111111");
			QSignalSpy spy(&context, &ChangePinContext::fireNewPinChanged);

			context.setNewPin(pin1);
			QCOMPARE(context.getNewPin(), pin1);
			QCOMPARE(spy.count(), 1);

			context.setNewPin(pin2);
			QCOMPARE(context.getNewPin(), pin2);
			QCOMPARE(spy.count(), 2);

			context.setNewPin(pin3);
			QCOMPARE(context.getNewPin(), pin2);
			QCOMPARE(spy.count(), 2);
		}


		void test_SuccessMessage()
		{
			ChangePinContext context;
			const QString message1 = QStringLiteral("message1");
			const QString message2 = QStringLiteral("message2");
			const QString message3 = QStringLiteral("message2");
			QSignalSpy spy(&context, &ChangePinContext::fireSuccessMessageChanged);

			context.setSuccessMessage(message1);
			QCOMPARE(spy.count(), 1);
			QCOMPARE(context.getSuccessMessage(), message1);

			context.setSuccessMessage(message2);
			QCOMPARE(spy.count(), 2);
			QCOMPARE(context.getSuccessMessage(), message2);

			context.setSuccessMessage(message3);
			QCOMPARE(spy.count(), 2);
			QCOMPARE(context.getSuccessMessage(), message2);
		}


		void test_RequestTransportPin()
		{
			{
				ChangePinContext context;
				QVERIFY(!context.requestTransportPin());
			}
			{
				ChangePinContext context(false);
				QVERIFY(!context.requestTransportPin());
			}
			{
				ChangePinContext context(true);
				QVERIFY(context.requestTransportPin());
			}
		}


};

QTEST_GUILESS_MAIN(test_ChangePinContext)
#include "test_ChangePinContext.moc"
