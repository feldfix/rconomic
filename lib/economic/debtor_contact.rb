require 'economic/entity'

module Economic

  # Represents a debtor contact.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IDebtorContact.html
  #
  # Examples
  #
  #   # Find contact
  #   contact = economic.contacts.find(:id => 5)
  #
  #   # Creating a contact
  #   contact = debtor.contacts.build
  #   contact.id = 0
  #   contact.number = 0
  #   contact.name = 'John Appleseed'
  #   contact.save
  class DebtorContact < Entity
    has_properties :id,
      :debtor_handle,
      :name,
      :number,
      :telephone_number,
      :email,
      :comments,
      :external_id,
      :is_to_receive_email_copy_of_order,
      :is_to_receive_email_copy_of_invoice

    def debtor
      return nil if debtor_handle.nil?
      @debtor ||= session.debtors.find(debtor_handle[:number])
    end

    def debtor=(debtor)
      self.debtor_handle = debtor.handle
      @debtor = debtor
    end

    def debtor_handle=(handle)
      @debtor = nil unless handle == @debtor_handle
      @debtor_handle = handle
    end

    def handle
      @handle || Handle.new({:id => @id})
    end

    protected

    def build_soap_data
      Economic::Entity::Mapper.new(self, fields).to_hash
    end

    # Returns the field rules to use when mapping to SOAP data
    def fields
      [
        ["Handle", :handle, Proc.new { |v| v.to_hash }, :required],
        ["Id", :handle, Proc.new { |v| v.id }, :required],
        ["DebtorHandle", :debtor, Proc.new { |v| v.handle.to_hash }],
        ["Name", :name, nil, :required],
        ["Number", :handle, Proc.new { |v| v.number }],
        ["TelephoneNumber", :telephone_number],
        ["Email", :email],
        ["Comments", :comments],
        ["ExternalId", :external_id],
        ["IsToReceiveEmailCopyOfOrder", :is_to_receive_email_copy_of_order, Proc.new { |v| v || false }, :required],
        ["IsToReceiveEmailCopyOfInvoice", :is_to_receive_email_copy_of_invoice, Proc.new { |v| v || false }, :required]
      ]
    end
  end
end
