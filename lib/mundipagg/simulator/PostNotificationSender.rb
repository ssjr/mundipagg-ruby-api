require 'uri'
require 'net/http'

module Mundipagg
  module Simulator
    # Class who simulates a Mundipagg post notification
    class PostNotification

      # Method who generate a Xml with random data to simulate a transaction POST notification.
      #
      # @returns [String] response
      def self.SendPostWithRandomData(url, type)

        types = {:credit=>1, :boleto=>2, :online_debit=>3}

        if not types.include? type
          raise(ArgumentError, ":type is not valid. It should be :credit, :boleto or :online_debit.")
        end

        uri = URI(url)
        xml = ''

    	amount = Array.new(5){[*'0'..'9'].sample}.join
    	previous_status = Array.new(1){['PartialPaid', 'Paid', 'Voided', 'Refunded', 'Generated'].sample}.join
    	actual_status = previous_status

    	until actual_status != previous_status
			actual_status = Array.new(1){['Paid', 'Voided', 'Opened'].sample}.join
    	end


        if type == :credit
        	
			xml = "<StatusNotification xmlns=\"http://schemas.datacontract.org/2004/07/MundiPagg.NotificationService.DataContract\"
										xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">
								<AmountInCents>"+amount+"</AmountInCents>
								<AmountPaidInCents>0</AmountPaidInCents>
								<BoletoTransaction i:nil=\"true\"/>
								<CreditCardTransaction>
									<Acquirer>"+Array.new(1){['Cielo', 'Redecard'].sample}.join+"</Acquirer>
									<AmountInCents>"+amount+"</AmountInCents>
									<AuthorizedAmountInCents>"+amount+"</AuthorizedAmountInCents>
									<CapturedAmountInCents>"+amount+"</CapturedAmountInCents>
									<CreditCardBrand>"+Array.new(1){['Visa', 'Mastercard', 'Amex'].sample}.join+"</CreditCardBrand>
									<RefundedAmountInCents i:nil=\"true\"/>
									<StatusChangedDate>"+Time.at(rand * Time.now.to_i).strftime('%FT%T%')+"</StatusChangedDate>
									<TransactionIdentifier>"+Array.new(12){[*'0'..'9', *'A'..'Z'].sample}.join+"</TransactionIdentifier>
									<TransactionKey>00000000-0000-0000-0000-000000000000</TransactionKey>
									<TransactionReference>"+Array.new(12){[*'A'..'Z'].sample}.join+"</TransactionReference>
									<UniqueSequentialNumber>"+Array.new(6){[*'0'..'9'].sample}.join+"</UniqueSequentialNumber>
									<VoidedAmountInCents i:nil=\"true\"/>
									<PreviousCreditCardTransactionStatus>"+previous_status+"</PreviousCreditCardTransactionStatus>
									<CreditCardTransactionStatus>"+actual_status+"</CreditCardTransactionStatus>
								</CreditCardTransaction>
								<MerchantKey>00000000-0000-0000-0000-000000000000</MerchantKey>
								<OrderKey>00000000-0000-0000-0000-000000000000</OrderKey>
								<OrderReference>"+Array.new(12){[*'A'..'Z', *0..9].sample}.join+"</OrderReference>
								<OrderStatus>"+Array.new(1){[].sample}.join+"</OrderStatus>
							</StatusNotification>"
        elsif type == :boleto
			xml = "<StatusNotification xmlns=\"http://schemas.datacontract.org/2004/07/MundiPagg.NotificationService.DataContract\"
										xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">
					<AmountInCents>"+amount+"</AmountInCents>
					<AmountPaidInCents>"+amount+"</AmountPaidInCents>
					<BoletoTransaction>
						<AmountInCents>"+amount+"</AmountInCents>
						<AmountPaidInCents>"+amount+"</AmountPaidInCents>
						<BoletoExpirationDate>"+Time.at(rand * Time.now.to_i).strftime('%FT%T%')+"</BoletoExpirationDate>
						<NossoNumero>"+Array.new(8){[*0..9].sample}.join+"</NossoNumero>
						<StatusChangedDate>"+Time.at(rand * Time.now.to_i).strftime('%FT%T%')+"</StatusChangedDate>
						<TransactionKey>00000000-0000-0000-0000-000000000000</TransactionKey>
						<TransactionReference>"+Array.new(12){[*'A'..'Z'].sample}.join+"</TransactionReference>
						<PreviousBoletoTransactionStatus>"+previous_status+"</PreviousBoletoTransactionStatus>
						<BoletoTransactionStatus>"+actual_status+"</BoletoTransactionStatus>
					</BoletoTransaction>
					<CreditCardTransaction i:nil=\"true\"/>
					<MerchantKey>00000000-0000-0000-0000-000000000000</MerchantKey>
					<OrderKey>00000000-0000-0000-0000-000000000000</OrderKey>
					<OrderReference>"+Array.new(12){[*'A'..'Z', *0..9].sample}.join+"</OrderReference>
					<OrderStatus>"+Array.new(1){['Paid', 'PartialPaid', 'WithError'].sample}.join+"</OrderStatus>
				</StatusNotification>"
        end

        xml = xml.strip
        xml = xml.gsub! /\t/, ''
        xml = xml.gsub! /\n/, ''

        res = Net::HTTP.post_form(uri, 'xmlNotification' => xml)

        return res.body, res.code
      end

    end
  end
end