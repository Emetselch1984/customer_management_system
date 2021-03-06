class Staff::ProgramsController < ApplicationController
  def index
    @programs = Program.listing.page(params[:page])
  end

  def new
    @program = Program.new
  end

  def show
    @program = Program.listing.find(params[:id])
  end

  def edit
    @program = Program.find(params[:id])
    @program.init_virtual_attributes
  end

  def create
    @program = Program.new
    @program.assign_attributes(program_params)
    @program.registrant = current_user
    if @program.save
      redirect_to staff_programs_path, notice: 'プログラムを登録しました。'
    else
      flash.now.alert = '⼊⼒に誤りがあります。'
      render :new
    end
  end

  def update
    @program = Program.find(params[:id])
    @program.assign_attributes(program_params)
    if @program.save
      redirect_to staff_programs_path, notice: 'プログラムを更新しました。'
    else
      flash.now.alert = '⼊⼒に誤りがあります。'
      render :edit
    end
  end

  def destroy
    program = Program.find(params[:id])
    program.destroy!
    redirect_to staff_programs_path, notice: 'プログラムを削除しました'
  end

  private

  def program_params
    params.require(:program).permit(%i[
                                      title
                                      application_start_date
                                      application_start_hour
                                      application_start_minute
                                      application_end_date
                                      application_end_hour
                                      application_end_minute
                                      min_number_of_participants
                                      max_number_of_participants
                                      description
                                    ])
  end
end
