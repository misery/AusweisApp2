/*!
 * \brief Mock a QNetworkReply for tests.
 *
 * \copyright Copyright (c) 2015-2018 Governikus GmbH & Co. KG, Germany
 */

#pragma once

#include "MockSocket.h"

#include <http_parser.h>
#include <QNetworkReply>

class test_StateCheckRefreshAddress;

namespace governikus
{

class MockNetworkReply
	: public QNetworkReply
{
	Q_OBJECT

	private:
		friend class ::test_StateCheckRefreshAddress;
		MockSocket mSocket;

	public:
		MockNetworkReply(const QByteArray& pData = QByteArray(), http_status pStatusCode = HTTP_STATUS_OK, QObject* pParent = nullptr);
		virtual ~MockNetworkReply() override;
		virtual void abort() override
		{
		}


		void setRequest(const QNetworkRequest& pRequest)
		{
			QNetworkReply::setRequest(pRequest);
		}


		virtual qint64 readData(char* pDst, qint64 pMaxSize) override;

		void fireFinished()
		{
			Q_EMIT finished();
		}


		void setNetworkError(NetworkError pErrorCode, const QString& pErrorString)
		{
			setError(pErrorCode, pErrorString);
		}


		void setFileModificationTimestamp(const QVariant& pTimestamp)
		{
			setHeader(QNetworkRequest::KnownHeaders::LastModifiedHeader, pTimestamp);
		}


};

} // namespace governikus
